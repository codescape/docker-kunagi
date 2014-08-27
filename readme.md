Docker Kunagi
=============

This small project was initially developed during a coding afternoon at my employer together with a peer. Please bear in mind that this was our first attempt to bring a Docker configuration up and running. So it might be far from optimal but we managed to get a Kunagi instance started on the provided Apache Tomcat instance.

Getting Started
---------------

This guide expects you to have Homebrew and Cask installed.

    # install VirtualBox
    brew cask install virtualbox

    # install Docker
    brew install docker
    brew install boot2docker

    # create docker vm
    boot2docker init
    boot2docker up
    export DOCKER_HOST=tcp://localhost:2375

    # create and run image on Dockerfile
    docker build -t kunagi . 
    docker run -d -p 8080:8080 kunagi

    # forward port from the virtual box (only osx)
    VBoxManage controlvm boot2docker-vm natpf1 "8080,tcp,127.0.0.1,8080,,8080"

Now your Docker image is created and started. The external port 8080 will be redirect to the internal port 8080 where your Apache Tomcat instance is running. If everything went fine you can now access the Kunagi instance on [http://localhost:8080/kunagi]().
