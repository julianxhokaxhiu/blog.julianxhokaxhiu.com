---
layout: single
title: 'How to run LocalAI inside a Proxmox LXC container on a MinisForum N5 Pro/Max with GPU and NPU fully working'
date: '2026-05-25 18:00:00'
aliases: [/minisforum-n5-local-ai-proxmox/index.html]
cover: /images/posts/FF8-New-Game.png
---

I've been stumbling around this topic for quite a while hoping to find a guide on how to build a VM inside Proxmox that would allow you to virtualize the nodes required to run your favourite Local AI solution using your GPU/NPU, and while doing so, maximize the performance as claimed by the vendor. Today this post will be about how I managed to get my own LXC container running inside Proxmox successfully while being able to run at almost 80 TOPS using the GPU and almost 20 TOPS using the NPU ( for around 100 TOPS combined ).

## The hardware configuration

Before getting down the rabbit hole, here is my current Hardware configuration:

- [Minisforum N5 Pro](https://www.minisforum.com/it/products/n5-pro) ( running atop the [AMD Ryzen™ AI 9 HX 370](https://www.amd.com/en/products/processors/laptop/ryzen/ai-300-series/amd-ryzen-ai-9-hx-370.html) )
- Crucial RAM DDR5 96GB Kit 5600Mhz (CT2K48G56C46S5)
- Stock 128GB SSD ( default one from Minisforum )
- Crucial P310 SSD 1TB PCIe Gen4 NVMe M.2 2280
- [BIOS 1.05](https://pc-file-web.oss-cn-shenzhen.aliyuncs.com/N5%20%20N5PRO/Bios/F8NAA_STX_1.05_260331.zip) ( you can get it from [their support page](https://www.minisforum.com/it/pages/product-info) )

## The BIOS configuration

Once booted it is important that you configure the following BIOS settings to get the maximum of your GPU performance:

- Set setting to stock
- Set `UMA size` to `Auto` ( should default to 32GB for a <=96GB RAM setup, 16GB for a <=64GB and 8GM for <=32 )

## The virtualization configuration

For the software part I decided to use Proxmox as I want to use this server also for other purposes that is not only related to AI, however the rest of the guide works as well also in case you decide to use this mini server only for AI as well.

- Download and install [Proxmox VE 9.2](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso/proxmox-ve-9-2-iso-installer)
- Update Proxmox and make sure you are at least on `Linux 7.0.2-6-pve` or newer

## The container configuration

### Step 1 - LXC creation

Now that we have Proxmox fully running and ready to go, create an LXC container using the `archlinux_base` template, whichever is the latest in the list. I'm personally going for Arch since it's the most straightforward to get everything up and running very easily.

- Enable `Unprivileged` when asked
- Set a default `root` password ( suggested )
- Provide at least 12 cores
- Provide at least 48GB of RAM
- Provide at least 128GB of disk ( enough to fit 4-5 models )

Once created open the console inside and run the following commands:

```sh
$ pacman-key --init
$ pacman-key --populate archlinux
$ pacman -Syu
```

They will be required to be able to continue install the rest of then packages.

### Step 2 - Forward GPU/NPU

Once you've completed the initialization and package upgrades, the next step is to forward the GPU/NPU. In order to do so, the first thing you want to do is find out the group IDs for the `render` and `video` groups. We will need them for later.

In order to find them run the following command:

```sh
$ cat /etc/group | grep -i 'render\|video'
render:x:987:
video:x:983:
```
As you can see in my case the two groups have the following IDs ( render=987, video=983 ). Note these numbers down.

Next you turn off the LXC, note its number ( for eg. `100` ), then in the Proxmox host open its configuration file ( for eg. `/etc/pve/lxc/100.conf`). Add the following lines inside the file:

```conf
dev0: /dev/dri/renderD128,gid=987 # render group
dev1: /dev/dri/card0,gid=983 # video group
dev2: /dev/kfd,gid=987 # render group
dev3: /dev/accel/accel0,gid=987 # render group
lxc.prlimit.memlock: unlimited # required by FLM
```

Note the `gid` parameter and the numbers, they MUST match the numbers you found inside your LXC container. This is required to ensure your applications can successfully use your GPU and NPU as if they were running on the host machine.

Save the file and turn on again the LXC.

### Step 3 - Getting the NPU up and running

Now it's the time to get the software to be able to talk to the hardware. In order to do so, under Arch you will need couple of dependencies.

```sh
# AMD XRT drivers
$ pacman -S xrt xrt-plugin-amdxdna
# NPU LLM engine
$ pacman -S fastflowlm
```

If everything worked correctly, you should be getting this output once you run `flm validate`:

```sh
$ flm validate
[Linux]  Kernel: 7.0.2-6-pve
[Linux]  NPU: /dev/accel/accel0 with 8 columns
[Linux]  NPU FW Version: 1.1.2.64
[Linux]  amdxdna version: 0.7
[Linux]  Memlock Limit: infinity
```

This confirms that your NPU is ready to be used by any LLM engine ( in this case, FLM ).

### Step 4 - Lemonade Server

In order to get the best of our Hardware we would prefer to use [Lemonade Server](https://lemonade-server.ai/) which is an engine implemented by AMD themselves, which wraps a set of LLM engines ( llamacpp, vllm, flm, etc. ). Each layer has been also patched to make use where possible to the various optimizations and advanced layers AMD provides, like [ROCm](https://www.amd.com/en/products/software/rocm.html).

To install it on Arch, you will need first to install an [AUR helper](https://wiki.archlinux.org/title/AUR_helpers), in my own case I prefer to use [yay](https://github.com/Jguer/yay).

To easily install it on your LXC, first we need to create a user that is not root, in this case let's name it `aur`:

```sh
$ useradd -m -G wheel aur
$ passwd aur # pick any password you want for this user
$ pacman -S git base-devel # install makepkg dependencies
$ su - aur
$ git clone https://aur.archlinux.org/yay-bin.git
$ cd yay-bin
$ makepkg -si # answer yes when asked to install the package
$ exit
```

This shall bring you back to your root user terminal in the LXC, but with `yay` installed. Next we'll install `lemonade` and enable it. In order to do so, run the following commands:

```sh
$ yay -S lemonade-server
$ usermod -aG render lemonade
$ usermod -aG video lemonade
$ systemctl enable --now lemond
$ lemonade status
Server is running on port 13305

Property            Value
--------------------------------------------------
Version             10.6.0
WebSocket Port      9000
Max Models/Type     1
```

If everything works like expected you should get this output, this confirms your lemonade instance is now ready to host LLMs. Now it's time to get `llamacpp:rocm` installed, in order to do so you can run:

```sh
$ lemonade backends install llamacpp:rocm
$ lemonade config set llamacpp.backend=rocm
$ lemonade backends
Recipe              Backend     Status          Message/Version                               Action
----------------------------------------------------------------------------------------------------------------------------------------------------
flm                 npu         installed       v0.9.42                                        -
kokoro              cpu         installable     Backend is supported but not installed.        lemonade backends install kokoro:cpu
                    metal       unsupported     Requires macOS                                 -
llamacpp            cpu         installable     Backend is supported but not installed.        lemonade backends install llamacpp:cpu
                    metal       unsupported     Requires macOS                                 -
                    rocm        installed       b9247                                          -
                    system      unsupported     llama-server not found in PATH                 -
                    vulkan      installable     Backend is supported but not installed.        lemonade backends install llamacpp:vulkan
ryzenai-llm         npu         unsupported     Requires Windows                               -
sd-cpp              cpu         installable     Backend is supported but not installed.        lemonade backends install sd-cpp:cpu
                    metal       unsupported     Requires macOS                                 -
                    rocm        installable     Backend is supported but not installed.        lemonade backends install sd-cpp:rocm
vllm                rocm        installable     Backend is supported but not installed.        lemonade backends install vllm:rocm
whispercpp          cpu         installable     Backend is supported but not installed.        lemonade backends install whispercpp:cpu
                    metal       unsupported     Requires macOS                                 -
                    npu         unsupported     Requires Windows                               -
                    vulkan      installable     Backend is supported but not installed.        lemonade backends install whispercpp:vulkan
----------------------------------------------------------------------------------------------------------------------------------------------------
```

If everything worked you should be getting both `flm` and `llamacpp:rocm` detected as `installed`. You're now one step closer to run your favourite LLM.

In order to pull them down you can use `lemonade pull <modelname>` where `<modelname` can be one of the options listed in `lemonade list`. For eg. here I'm pulling the latest `Qwen3.6-35B-A3B-MTP-GGUF`:

```sh
$ lemonade list
Model Name                              Downloaded  Details
----------------------------------------------------------------------------------------------------
# [...]
Qwen3.6-35B-A3B-MTP-GGUF                No          llamacpp
# [...]
$ lemonade pull Qwen3.6-35B-A3B-MTP-GGUF
```

Once you pull it, you're almost ready to run it, but before doing so let's install a proper UI for it.

### Step 5 - Open WebUI

[Open WebUI](https://docs.openwebui.com/) is one of the most known de-facto solution to have a similar UI like you're used to ChatGPT or Claude, but locally on your own server. Luckily for us, the project offers many ways to install it, but in our case we'll use again the AUR repository to install it and run it very easily.

In order to do run the following commands:

```sh
$ yay -S open-webui-uv
$ systemctl enable --now open-webui
```

After some time ( depending on the speed of your connection as it will pull dependencies required by Open WebUI to run ), you should be able to access it at http://localhost:8080 ( remember to replace `localhost` with your VM IP ).

Once you open the page, you'll be asked to create your first admin account in it, do so and reach the main page. Once there, we need to integrate Lemonade with Open WebUI. To do so, you can follow the [official configuration guide](https://lemonade-server.ai/docs/integrations/open-webui/#configuring-open-webui).

Remember that in your own case the API endpoint will be `http://localhost:13305/api/v1` as Lemonade is opened only to the localhost network in the LXC, not outside ( unlike Open WebUI which is opened to all the interfaces ). Once you set that up, refresh the page and you shall be able to finally see your downloaded models in the dropdown on the top.

Before starting to chat, I would also suggest to enable couple of settings:

- Enable the Web Search capability at http://localhost:8080/admin/settings/web
- Go to http://localhost:8080/admin/settings/models -> Settings -> Defaults -> Model capabilities -> enable all the `Default Deatures` like `Web Search`, `Image generation` and `Code interpreter`

This should give you a good ground to start.

### And more to learn

If you managed to reach until this point be very proud of yourself, running local AI that works like the commercial solutions out there is not a simple activity but this setup will give you a very good ground which now the performance bottleneck will be only on your own hardware. If you have a dedicated GPU to spare clearily you can get much better performance than 100 TOPS, but for an embedded machine that does many things, and also AI, it's not that bad :)

I hope you did enjoy this tutorial, until next time!
