# Docker for Mkdocs

This is a project that uses Docker to encapsulate Mkdocs. 

It essentially wraps the mkdocs binaries and processing into a Docker image, so given a directory with a valid mkdocs 
structure, the Docker container can both render and host the built static website without requiring mkdocs itself 
to be installed locally.

## How to build

```bash
docker build . -t <docker-image-name>
```

## How to run
The Docker container can be run with either the `produce` or `serve` commands

### produce
The `produce` command
  1. takes a path to a mkdocs project on the local host as an argument, 
  2. internally does a `mkdocs build` on the project and
  3. streams the tar.gz of the static website to STDOUT

The path to the local mkdocs project is passed to the docker container as a volume. The container expects this volume
to be mounted at `/data/mkdocs-project`.

#### Assumptions
This assumes that the mkdocs project being passed in follows a basic structure similar to below. The `mkdocs build` 
command outputs the static website files into the default `site` dir.
```
mkdocs-project/
  docs/
    about.md
    index.md
  mkdocs.yml
  site/
```

#### Syntax
```bash
docker run -v /local/path/to/mkdocs-project:/data/mkdocs-project <docker-image-name> produce
```
Example (including redirecting STDOUT to a tar.gz file):
```bash
docker run -v ~/data/mkdocs-project:/data/mkdocs-project mkdocs produce > mkdocs-project.tar.gz
```

### serve
The `serve` command
  1. Reads a tgz file, produced by the `produce` command, from STDIN,
  2. Untars the tgz file and restructures it into a valid mkdocs project and
  3. Serves the static web content via `mkdocs serve`

#### Assumptions
This assumes the tgz file was produced by the output of the `produce` command with a mkdocs project that follows the 
same structure as the assumption in the `produce` command.

Since the requirement for the `produce` command was for the contents of `site` to be at the root of the tgz file, the
tgz file had to be manipulated to include the `mkdocs.yml` and `docs/` files. These files are moved back out to one dir
higher before calling `mkdocs serve`.

Also, strictly speaking, `mkdocs serve` uses a builtin development server which is primarily intended for local 
development. There are more robust web servers out there for production deployment, but the assignment makes it clear 
that the Docker container should "use Mkdocs internally to serve it." 

#### Syntax
```bash
docker run -p 8000:8000 -i <docker-image-name> serve
```
Example (including reading tar.gz file from STDIN):
```bash
docker run -p 8000:8000 -i mkdocs serve < mkdocs-project.tar.gz
```

### Putting them together
Both `produce` and `serve` commands can be piped together to avoid having to create a phsyical tar.gz file in between
```bash
docker run -v ~/data/mkdocs-project:/data/mkdocs-project mkdocs produce | docker run -p 8000:8000 -i mkdocs serve
```

## About the project
### Dockerfile
The Dockerfile is quite minimal and straightforward. 
  1. We start with a python image and proceed to install mkdocs via pip.
  2. We copy the `mkdockerize.sh` script into the working directory root
  3. We specify `mkdockerize.sh` as the entrypoint command for the container, so all arguments will be directed to this command
  
### mkdockerize.sh
This is where the bulk of the logic is. 

The script is essentially a wrapper to parse and validate the commands from the commandline ("produce" or "serve") 
and invoke `mkdocs build` or `mkdocs serve` accordingly, with support to stream tar.gz data to and from STDOUT and 
STDIN respectively. 

It makes certain assumptions as to the structure of the mkdocs project itself. Some additional error-handling could 
probably be done here as well as future improvements to handle invalid structures. 

### Jenkinsfile
This contains a bare minimum Jenkins pipeline with 'build' and 'test' stages, as per the requirement. It wasn't 
clear what exactly these stages were supposed to do, though. 

The 'build' stage currently just echoes something to stdout since there really isn't anything to "build" in this 
project in the traditional sense. If this were a java project, for example, the build stage would invoke some 
kind of build framework (e.g. maven or gradle) to compile the code, run unit-tests, etc. 

The 'test' stage is where you could run more advanced or long-running tests (integration tests, smoke tests, 
acceptance tests, etc). For the sake of example I've included another shell script that does some crude unit-testing
of the mkdockerize.sh script. 

Alternatively, the build stage could invoke the 'produce' and 'serve' functionality, while the test stage could access
the served mkdocs via curl or other web testing framework. But this would only work if docker itself were installed
on the Jenkins instance. In my case, the Jenkins instance I was testing on was running on docker already, so this 
wasn't possible.