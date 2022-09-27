build:
	dpkg-deb --build dsp

install:
	sudo apt install -f ./dsp.deb
