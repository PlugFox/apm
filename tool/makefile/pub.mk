.PHONY: version doctor clean get upgrade upgrade-major outdated dependencies

version:
	@flutter --version

doctor:
	@flutter doctor

clean:
	@rm -rf coverage .dart_tool .packages pubspec.lock

get:
	@flutter pub get

upgrade:
	@flutter pub upgrade

upgrade-major:
	@flutter pub upgrade --major-versions

outdated: get
	@flutter pub outdated

dependencies: upgrade
	@flutter pub outdated --dependency-overrides \
		--dev-dependencies --prereleases --show-all --transitive
