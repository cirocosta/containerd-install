WHAT

	a minimal containerd install


USAGE

	make
	sudo service containerd status

		● containerd.service - containerd container runtime
		   Loaded: loaded (/etc/systemd/system/containerd.service; enabled; vendor preset: enabled)
		   Active: active (running) since Fri 2019-11-15 15:14:31 UTC; 4s ago
		     Docs: https://containerd.io
		  Process: 30882 ExecStartPre=/sbin/modprobe overlay (code=exited, status=0/SUCCESS)
		 Main PID: 30883 (containerd)
		    Tasks: 13
		   Memory: 22.8M
		   CGroup: /system.slice/containerd.service
			   └─30883 /usr/local/concourse/bin/containerd --config=/usr/local/concourse/conf/containerd.toml

