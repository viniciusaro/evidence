build_runner_build:
	@echo "Generating domain..."
	@cd core/evidence_domain; dart run build_runner build --delete-conflicting-outputs& 

	@echo "Generating backend..."
	@cd evidence_backend;dart run build_runner build --delete-conflicting-outputs&

build_runner_watch:
	@echo "Generating domain..."
	@cd core/evidence_domain; dart run build_runner watch --delete-conflicting-outputs&

	@echo "Generating backend..."
	@cd evidence_backend;dart run build_runner watch --delete-conflicting-outputs&