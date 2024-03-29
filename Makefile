include .env
.ONESHELL:

MULTIEXIST = $(shell multipass list | grep 'dsp' | cut -d " " -f1)
VERSION = 3.8.0
DEB_DSP = dsp_$(VERSION)_amd64.deb
# Avoid zsd compression
build:
	dpkg-deb -Zxz --build dsp $(DEB_DSP)

ppa-clone:
	git clone git@github.com:DockerSecurityPlayground/ppa.git
ppa: build
	rm  ppa/*
	mv $(DEB_DSP) ppa
	cd ppa
	gpg --armor --export "${EMAIL}" > KEY.gpg
	dpkg-scanpackages --multiversion . > Packages
	gzip -k -f Packages
	apt-ftparchive release . > Release
	gpg --default-key "${EMAIL}" -abs -o - Release > Release.gpg
	gpg --default-key "${EMAIL}" --clearsign -o - Release > InRelease


	echo "deb https://dockersecurityplayground.github.io/ppa/ ./" > dsp.list

	git add -A  
	git commit -am "Updated $(shell date)"
	git push 

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
