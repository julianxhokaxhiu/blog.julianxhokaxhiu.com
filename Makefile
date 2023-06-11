.fix_permissions:
	@chmod +x .env.sh

default: .fix_permissions
	@./.env.sh -F serve . --bind 0.0.0.0

build: .fix_permissions
	@./.env.sh

clean: .fix_permissions
	@./.env.sh clean
