MULTIEXIST = $(shell multipass list | grep 'dsp' | cut -d " " -f1)
VERSION = 3.8.0
DEB_DSP = dsp_$(VERSION)_amd64.deb
build:
	dpkg-deb --build dsp $(DEB_DSP)

ppa: build
	git clone git@github.com:DockerSecurityPlayground/ppa.git
	mv $(DEB_DSP)
	cd ppa
	git add -A  
	git commit -am "Updated $(date)"

install:
	sudo apt install -f ./dsp.deb

test: 
ifeq ($(MULTIEXIST),dsp)  
	@echo "dsp instance exist"
	multipass start dsp
else
	multipass launch --name dsp 22.04
	multipass mount . dsp:/home/ubuntu/dsp-install
endif
	multipass shell dsp