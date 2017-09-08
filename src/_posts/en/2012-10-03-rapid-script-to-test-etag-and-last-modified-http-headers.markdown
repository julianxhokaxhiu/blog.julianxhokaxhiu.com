---
layout: single
title: Rapid script to test 'Etag' and 'Last-Modified' HTTP Headers
date: '2012-10-03 22:03:50'
tags:
- php
---

Are you searching for a rapid PHP script to test "**Etag**" or "**Last-Modified**" HTTP Headers in your project? Here we go, made in PHP.

Enjoy

```php
<?php
    // Uncomment these lines to get ALWAYS an HTTP 200 Response
    //$date = "";
    //$etag = "";
    // Uncomment these lines to get an HTTP 304 Response, if response is already cached, otherwise HTTP 200 Response
    $date = "Tue, 31 Jul 2012 16:22:39 GMT";
    $etag = "bdfe45db3bc212446299db6f327c4ec0";

    // Let's set the correct headers to get cache control with If-Modified-Since or If-None-Match headers
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Expose-Headers: ETag");
    header("Access-Control-Expose-Headers: X-Content-Length-Uncompressed");
    header("Access-Control-Expose-Headers: Content-Length");
    header("Cache-Control: public");
    header("Content-Type: application/json");
    header("ETag: $etag");
    header("Last-Modified: $date");

    // Here we create a test object for the response to be cached
    $testobj = array();
    $testobj['test'] = true;

    // Here we check if content is modified with If-Modified-Since or If-None-Match headers in request
    if((!empty($_SERVER['HTTP_IF_MODIFIED_SINCE']) && $_SERVER['HTTP_IF_MODIFIED_SINCE'] == $date) || (!empty($_SERVER['HTTP_IF_NONE_MATCH']) && $_SERVER['HTTP_IF_NONE_MATCH'] == $etag)){
        header("HTTP/1.1 304 Not Modified");
    // Nothing cached, let's give out the content
    }else{
        echo json_encode($testobj);
    }
?>
```