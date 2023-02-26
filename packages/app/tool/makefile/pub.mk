.PHONY: version doctor clean get codegen upgrade upgrade-major outdated dependencies

version:
	@fvm flutter --version

doctor:
	@fvm flutter doctor

clean:
	@rm -rf coverage .dart_tool .packages pubspec.lock

get:
	@fvm flutter pub get

codegen: get
	@fvm flutter pub run build_runner build --delete-conflicting-outputs
	@dart pub global run intl_utils:generate
	@protoc --dart_out=grpc:lib/src/common/model/generated -Iprotos protos/apm.proto
	@fvm flutter format --fix -l 120 .

upgrade:
	@fvm flutter pub upgrade

upgrade-major:
	@fvm flutter pub upgrade --major-versions

outdated: get
	@fvm flutter pub outdated

dependencies: upgrade
	@fvm flutter pub outdated --dependency-overrides \
		--dev-dependencies --prereleases --show-all --transitive

fix:
	@fvm flutter format --fix -l 120 .