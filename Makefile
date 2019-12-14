CNI_VERSION        = v0.8.2
CONTAINERD_VERSION = 1.3.0
RUNC_VERSION       = v1.0.0-rc8
INIT_VERSION       = 1.2.2

CNI_URL        = https://github.com/containernetworking/plugins/releases/download/$(CNI_VERSION)/cni-plugins-linux-amd64-$(CNI_VERSION).tgz
CONTAINERD_URL = https://github.com/containerd/containerd/releases/download/v$(CONTAINERD_VERSION)/containerd-$(CONTAINERD_VERSION).linux-amd64.tar.gz
INIT_URL       = https://github.com/Yelp/dumb-init/releases/download/v$(INIT_VERSION)/dumb-init_$(INIT_VERSION)_amd64
RUNC_URL       = https://github.com/opencontainers/runc/releases/download/$(RUNC_VERSION)/runc.amd64

BIN_DIR  = /usr/local/kubelet-sample/bin
CONF_DIR = /usr/local/kubelet-sample/conf


all: | binaries configuration systemd


clean:
	sudo rm -r $(BIN_DIR) || true
	sudo rm -r $(CONF_DIR) || true
	sudo service containerd stop || true
	sudo rm /etc/systemd/system/containerd.service
	sudo systemctl daemon-reload


binaries:
	sudo mkdir -p $(BIN_DIR)
	sudo chown -R $(shell whoami) $(BIN_DIR)
	curl -sSL $(RUNC_URL) -o $(BIN_DIR)/runc && chmod +x $(BIN_DIR)/runc
	curl -sSL $(INIT_URL) -o $(BIN_DIR)/init && chmod +x $(BIN_DIR)/init
	curl -sSL $(CONTAINERD_URL) | sudo tar -zvxf - -C $(BIN_DIR) --strip-components 1
	curl -sSL $(CNI_URL)        | sudo tar -zvxf - -C $(BIN_DIR)


configuration:
	sudo mkdir -p $(CONF_DIR)/cni
	sudo chown -R $(shell whoami) $(CONF_DIR)
	cp ./containerd.toml $(CONF_DIR)/containerd.toml
	cp ./cni.json $(CONF_DIR)/cni/cni.json


systemd:
	mkdir -p /etc/systemd/system
	sudo cp ./containerd.service /etc/systemd/system/containerd.service
	sudo systemctl daemon-reload
	sudo service containerd start
