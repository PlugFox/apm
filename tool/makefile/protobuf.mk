.PHONY: setup codegen

# choco install protoc
# brew install protobuf
# export PATH="$PATH:$PUB_CACHE/bin"
setup:
	@dart pub global activate protoc_plugin

codegen: get
#	@dart pub run build_runner build --delete-conflicting-outputs
	@protoc --dart_out=grpc:lib/src/generated -Iprotos protos/apm.proto