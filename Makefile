CNI_VERSION        = v0.8.2
CONTAINERD_VERSION = 1.3.0
RUNC_VERSION       = v1.0.0-rc8

CNI_URL        = https://github.com/containernetworking/plugins/releases/download/$(CNI_VERSION)/cni-plugins-linux-amd64-$(CNI_VERSION).tgz
CONTAINERD_URL = https://github.com/containerd/containerd/releases/download/v$(CONTAINERD_VERSION)/containerd-$(CONTAINERD_VERSION).linux-amd64.tar.gz
RUNC_URL       = https://github.com/opencontainers/runc/releases/download/$(RUNC_VERSION)/runc.amd64

BIN_DIR  = /usr/local/concourse/bin
CONF_DIR = /usr/local/concourse/conf


setup: binaries configuration


clean:
	sudo rm -r $(BIN_DIR) || true
	sudo rm -r $(CONF_DIR) || true


binaries:
	sudo mkdir -p $(BIN_DIR)
	sudo chown -R $(shell whoami) $(BIN_DIR)
	curl -sSL $(RUNC_URL) -o $(BIN_DIR)/runc && chmod +x $(BIN_DIR)/runc
	curl -sSL $(CONTAINERD_URL) | sudo tar -zvxf - -C $(BIN_DIR) --strip-components 1
	curl -sSL $(CNI_URL)        | sudo tar -zvxf - -C $(BIN_DIR)


configuration:
	sudo mkdir -p $(CONF_DIR)
	sudo chown -R $(shell whoami) $(CONF_DIR)
	cp ./containerd.toml $(CONF_DIR)/containerd.toml
	cp ./cni.json $(CONF_DIR)/cni.json

