.PHONY: all vendor fmt

all: vendor fmt

vendor: .peru/lastimports
	peru reup

fmt: .pre-commit-config.yaml .stylua.toml .styluaignore .editorconfig
	pre-commit run -a

.peru/lastimports: peru.yaml
	peru sync
