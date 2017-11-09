---
separator: <!--s-->
verticalSeparator: <!--v-->
theme: black
revealOptions:
  transition: 'zoom'
  center: false
  controls: false
---

<!-- .slide: data-background="https://cdn.stocksnap.io/img-thumbs/960w/WYHG9KFNNC.jpg" -->
# DockerFu: The Art of Creating Images

#### PRESENTED BY: JOSEPH MATTHIAS GOH

<!--v-->

### `whoami`

> Joseph is a Full-Stack Web Developer™ and DevOps engineer creating and deploying awesome citizen-centric applications at Government Digital Services, GovTech Singapore

### `hmu`

- Non-Professional Affairs: <a href="mailto:hello@joeir.net" target="_blank">hello@joeir.net</a>
- Professional Affairs: <a href="mailto:joseph_goh@tech.gov.sg" target="_blank">joseph_goh@tech.gov.sg</a>

<!--s-->

<!-- .slide: data-background="https://cdn.stocksnap.io/img-thumbs/960w/KV6IATK4SM.jpg" -->
# Start With Why
## Use Cases of Images

<!--v-->

<!-- .slide: data-background="https://cdn.stocksnap.io/img-thumbs/960w/ELZCOUA467.jpg" -->
### Base Image

- contains just the operating system
- might also contain an application runtime
- generally small, lean, designed for extension
- useful as a start point for custom applications

> eg: [`alpine`](https://hub.docker.com/_/alpine/), [`ubuntu`](https://hub.docker.com/_/ubuntu/), [`centos`](https://hub.docker.com/_/centos/), [`alpine-node`](https://hub.docker.com/r/zephinzer/alpine-node/) 

<!--v-->

### Factory Image

- contains extra tools to assist in carrying out specific processes
- designed to successfully execute without errors
- useful as containers which build/test/deploy your application

> eg: [`gke-deployer`](https://hub.docker.com/r/zephinzer/gke-deployer/), [`ci-runner-docker`](https://hub.docker.com/r/zephinzer/ci-runner-docker/), 

<!--v-->

### Deployment Image

- focuses on environment standardisation
- contains runtimes, frameworks and a bundled, immutable code deployment
- used for deploying applications in specific environments (*ie* prod, uat, qa, ci)

> eg: `mcf/node:*`, `mcf/react:*`, `mcf/react-test:*`

<!--v-->

### Service Image

- usually a deploy-and-configure application
- used in service-ish applications that need little or even no configurations to work, like databases, caches, proxies

> eg: [`mysql`](https://hub.docker.com/_/mysql/), [`redis`](https://hub.docker.com/_/redis/), [`nginx`](https://hub.docker.com/_/nginx/), [`httpd`](https://hub.docker.com/_/httpd/), [`gitlab`](https://hub.docker.com/r/gitlab/gitlab-ce/), [`bamboo-base-agent`](https://hub.docker.com/r/atlassian/bamboo-base-agent/), [`teamcity/agent`](https://hub.docker.com/r/jetbrains/teamcity-agent/)

<!--v-->

## Use Cases of Images

- - -

### Base Image

### Factory Image

### Deployment Image

### Service Image

- - -

<!--s-->

<!-- .slide: data-background="https://cdn.stocksnap.io/img-thumbs/960w/FL3P0LG984.jpg" -->
# The Ideal Image

## Guiding Principles when crafting an image

<!--v-->

### Small

- physically small (~30MB?)
- quick distribution (download/pulling)
- efficient deployments (`ImagePullPolicy: Always`)

<!--v-->

### Lean

- contains only what is needed (side effect: small)
- secure by limiting available binaries
- secure by limiting available users & permissions

<!--v-->

### Extensible

- important for images destined for use in base images
- allows for installation of more software
- somewhat goes against *lean*, discretion advised!

<!--v-->

### Perpetual

- no maintenance needed
- allows for creator to publish once and automate a daily build that publishes latest version
- useful for public base images encapsulating software

<!--v-->

## The Ideal Image

- - -

### Small

### Lean

### Extensible

### Perpetual

- - -

<!--s-->

<!-- .slide: data-background="https://cdn.stocksnap.io/img-thumbs/960w/20GVW2WQKZ.jpg" -->
# Concepts/Entities of an Image

<!--v-->

### Dockerfile

- declarative programming language
- composed of `DIRECTIVE VALUE<>[]` statements
- each directive corresponds to a...

<!--v-->

### Step/Image Layer

- a "*step*" in the Docker Build process
- cached as an image that builds upon a previous image
- layers are stacked upon each other incrementally to build into the final...

<!--v-->

### Image

- a standalone, exportable snapshot of a system
- think of images as a class definition
- you instantiate images via `docker run` into a...

<!--v-->

### Container

- an instantiated image
- behaves like a virtual machine running on your host machine
- shares only the kernel with the base operating system
- based on the Linux kernel (on OS X and Windows, a Linux VM is being run in the background to provide this kernel)

<!--v-->

## Concepts/Entities of an Image

- - -

### Dockerfile

### Step/Image Layer

### Image

### Container

- - -

<!--s-->

<!-- .slide: data-background="https://cdn.stocksnap.io/img-thumbs/960w/5PZQA4FETA.jpg" -->
# Crafting the Image

## Towards `Successfully built...`

<!--v-->

### If you want to follow along

##### Link To Example Repository

https://github.com/zephinzer/writing-effective-docker-images-example-project

#### Got This Shiz?

```
> git clone https://github.com/zephinzer/writing-effective-docker-images-example-project.git
```


<!--v-->

### Choosing an Image

- what functionality do I require?
- is there an available image on DockerHub for me to pull and deploy?
- what runtime does my application require?
- what operating system supports my application's runtime?

<!--v-->

### Importing an Image (Method 1)

##### From Docker Hub

> `docker pull __author__/__repo__:__tag__`

<!--v-->

### Importing an Image (Method 2)

##### From Private Registry

`docker pull __registry_url__/__author__/__repo__:__tag__`

<!--v-->

### Importing an Image (Method 3)

##### From `tar.gz`

`docker load image-tarball.tar.gz`

<!--v-->

##### `FROM author/repo:tag`

```
* FROM alpine:3.6
```

<!--v-->

### Specify Environment Variables

- global variables
- define stuff you'll constantly reference
- avoid magic numbers and constants
- use them to make your Dockerfile readable

<!--v-->

##### `ENV var_name "value"`

```
  FROM alpine:3.6
* ENV APK_ADD="bash curl nodejs nodejs-npm yarn"
* ENV APK_DEL="bash curl yarn"
```

<!--v-->

### Install System Dependencies

- runtimes, frameworks, global stuff
- install it via the package manager for system we drew `FROM`
- for Alpine, we use `apk`

<!--v-->

##### `RUN`

##### `{apk, yum, apt-get, pacman, dnf}`

```
  FROM alpine:3.6
* RUN apk update
* RUN apk upgrade
  ENV APK_ADD="bash curl nodejs nodejs-npm yarn"
  ENV APK_DEL="bash curl yarn"
* RUN apk add --no-cache ${APK_ADD}
```

<!--v-->

### Import Code/Configurations

- get stuff from host to image
- via `COPY` and `ADD` directives
- `COPY` just copies files
- `ADD` can import URLs and tarballs too
- define a working directory using `WORKDIR`

<!--v-->

##### `COPY . /farfaraway`

```
  FROM alpine:3.6
  RUN apk update
  RUN apk upgrade
  ENV APK_ADD="bash curl nodejs nodejs-npm yarn"
  ENV APK_DEL="bash curl yarn"
  RUN apk add --no-cache ${APK_ADD}i
* WORKDIR /app
* COPY . /app
```

<!--v-->

### Install/Build

- install application specific dependencies
- eg. `npm`, `cocoapods`, `gem` : it depends on your application type
- for a Node image, we use the `yarn` package manager

<!--v-->

##### `RUN xxx install`

```
  FROM alpine:3.6
  RUN apk update
  RUN apk upgrade
  ENV APK_ADD="bash curl nodejs nodejs-npm yarn"
  ENV APK_DEL="bash curl yarn"
  RUN apk add --no-cache ${APK_ADD}i
  WORKDIR /app
  COPY . /app
* RUN yarn install
* RUN yarn build
```

<!--v-->

### Setup I/O Channels

- expose ports for other containers
- mount volumes for host/container or container/container file sharing
- specify entrypoint into system

<!--v-->

##### `{PORT, VOLUME, ENTRYPOINT}`

```
  FROM alpine:3.6
  RUN apk update
  RUN apk upgrade
  ENV APK_ADD="bash curl nodejs nodejs-npm yarn"
  ENV APK_DEL="bash curl yarn"
  RUN apk add --no-cache ${APK_ADD}i
  WORKDIR /app
  COPY . /app
  RUN yarn install
  RUN yarn build
* EXPOSE 3000
* VOLUME ["/app/pages"]
* ENTRYPOINT ["npm", "run"]
```

<!--v-->

### Excute Your Image (Part I)

##### Build It

```
docker build --no-cache -t my_image .
```
> note the trailing period which specifies context

<!--v-->

### Execute Your Image (Part II)

##### Run It

```
docker run \
  --name my_container \
  -p 2999:3000 \
  -v $(pwd)/pages:/app/pages:rw \
  my_image:latest \
  dev
```
> note the `dev`, it is appended to the `ENTRYPOINT` specified in the Dockerfile

<!--v-->

## Crafting the Image

- - -


#### Choose an Image


#### Import the Image


#### Specify Environment Variables


#### Install System Dependencies


#### Import Code/Configurations


#### Install Application Dependencies


#### Setup I/O Channels


#### Execute your Image

- - -

<!--s-->

<!-- .slide: data-background="https://cdn.stocksnap.io/img-thumbs/960w/S28MUJMXYJ.jpg" -->
# Enhancements & Optimisations

## Towards small, lean, extensible

<!--v-->

### Remove Useless Binaries & Artefacts

- remove useless stuff that takes up space
- g++ build headers (once you're confident no more builds are needed)
- `man` pages
- package manager caches - `yarn`, `apk` in our case
- system dependencies that are no longer needed

<!--v-->

##### The `rm -rf`

```
  FROM alpine:3.6
  RUN apk update
  RUN apk upgrade
  ENV APK_ADD="bash curl nodejs nodejs-npm yarn"
  ENV APK_DEL="bash curl yarn"
  RUN apk add --no-cache ${APK_ADD}i
  WORKDIR /app
  COPY . /app
  RUN yarn install
  RUN yarn build
* RUN yarn cache clean
* RUN rm -rf \
*   /usr/share/man/* \
*   /usr/includes/* \
*   /var/cache/apk/* \
*   /root/.npm/* \
*   /usr/lib/node_modules/npm/man/* \
*   /usr/lib/node_modules/npm/doc/* \
*   /usr/lib/node_modules/npm/html/* \
*   /usr/lib/node_modules/npm/scripts/*
* RUN apk del ${APK_DEL}
  EXPOSE 3000
  VOLUME ["/app/pages"]
  ENTRYPOINT ["npm", "run"]
```

<!--v-->

### Secure Permissions

- by default, Docker will run as `root`
- if application has an exploit, an attacker has root access to our container
- root access to container allows network discovery and further penetration
- solve this by adding an `app` user which executes your application

<!--v-->

##### The `rm -rf`

```
  FROM alpine:3.6
  RUN apk update
  RUN apk upgrade
  ENV APK_ADD="bash curl nodejs nodejs-npm yarn"
  ENV APK_DEL="bash curl yarn"
* ENV USERNAME="app"
* ENV USER_ID="1000"
  RUN apk add --no-cache ${APK_ADD}i
  WORKDIR /app
  COPY . /app
  RUN yarn install
  RUN yarn build
  RUN yarn cache clean
  RUN rm -rf \
    /usr/share/man/* \
    /usr/includes/* \
    /var/cache/apk/* \
    /root/.npm/* \
    /usr/lib/node_modules/npm/man/* \
    /usr/lib/node_modules/npm/doc/* \
    /usr/lib/node_modules/npm/html/* \
    /usr/lib/node_modules/npm/scripts/*
  RUN apk del ${APK_DEL}i
* RUN adduser -H -D ${USERNAME} -u ${USER_ID}
* RUN chown ${USERNAME}:${USERNAME} -R /app
* USER app
  EXPOSE 3000
  VOLUME ["/app/pages"]
  ENTRYPOINT ["npm", "run"]
````

<!--v-->

### Remove Useless Users

- most linux systems come with legacy users (eg. `shutdown`)
- these pose potential security risks, so we remove them to prevent the possibility of using these system users whether by accident or by malicious intent
- use `cat /etc/passwd` to see all users and remove accordingly

<!--v-->

##### `RUN deluser`

```
  FROM alpine:3.6
  RUN apk update
  RUN apk upgrade
  ENV APK_ADD="bash curl nodejs nodejs-npm yarn"
  ENV APK_DEL="bash curl yarn"
  ENV USERNAME="app"
  ENV USER_ID="1000"
  RUN apk add --no-cache ${APK_ADD}i
  WORKDIR /app
  COPY . /app
  RUN yarn install
  RUN yarn build
  RUN yarn cache clean
  RUN rm -rf \
    /usr/share/man/* \
    /usr/includes/* \
    /var/cache/apk/* \
    /root/.npm/* \
    /usr/lib/node_modules/npm/man/* \
    /usr/lib/node_modules/npm/doc/* \
    /usr/lib/node_modules/npm/html/* \
    /usr/lib/node_modules/npm/scripts/*
  RUN apk del ${APK_DEL}i
* RUN deluser --remove-home daemon
* RUN deluser --remove-home adm
* RUN deluser --remove-home lp
* RUN deluser --remove-home sync
* RUN deluser --remove-home shutdown
* RUN deluser --remove-home halt
* RUN deluser --remove-home postmaster
* RUN deluser --remove-home cyrus
* RUN deluser --remove-home mail
* RUN deluser --remove-home news
* RUN deluser --remove-home uucp
* RUN deluser --remove-home operator
* RUN deluser --remove-home man
* RUN deluser --remove-home cron
* RUN deluser --remove-home ftp
* RUN deluser --remove-home sshd
* RUN deluser --remove-home at
* RUN deluser --remove-home squid
* RUN deluser --remove-home xfs
* RUN deluser --remove-home games
* RUN deluser --remove-home postgres
* RUN deluser --remove-home vpopmail
* RUN deluser --remove-home ntp
* RUN deluser --remove-home smmsp
* RUN deluser --remove-home guest
  RUN adduser -H -D ${USERNAME} -u ${USER_ID}
  RUN chown ${USERNAME}:${USERNAME} -R /app
  USER app
  EXPOSE 3000
  VOLUME ["/app/pages"]
  ENTRYPOINT ["npm", "run"]
```

<!--v-->

### Add Build-Time Configurations

- `ARG` directive is the only one that can appear before `FROM`
- make your image extensible by allowing for build arguments
- `ARG` directives behave like `ENV` except that they are not persisted after the image is built (ie. you cannot reference them in the instantiated container)

<!--v-->

##### `ARGuements, arguments`

```
* ARG ALPINE_VERSION=3.6
  FROM alpine:${ALPINE_VERSION}
  RUN apk update
  RUN apk upgrade
* ARG APPLICATION_PATH=/app
  ENV APK_ADD="bash curl nodejs nodejs-npm yarn"
  ENV APK_DEL="bash curl yarn"
  ENV USERNAME="app"
  ENV USER_ID="1000"
  ENV USERNAME="app"
  ENV USER_ID="1000"
  RUN apk add --no-cache ${APK_ADD}
* WORKDIR ${APPLICATION_PATH}
* COPY . ${APPLICATION_PATH}
  RUN yarn install
  RUN yarn build
  RUN yarn cache clean
  RUN rm -rf \
        /usr/share/man/* \
        /usr/includes/* \
        /var/cache/apk/* \
        /root/.npm/* \
        /usr/lib/node_modules/npm/man/* \
        /usr/lib/node_modules/npm/doc/* \
        /usr/lib/node_modules/npm/html/* \
        /usr/lib/node_modules/npm/scripts/*
  RUN apk del ${APK_DEL}
  RUN deluser --remove-home daemon
  RUN deluser --remove-home adm
  RUN deluser --remove-home lp
  RUN deluser --remove-home sync
  RUN deluser --remove-home shutdown
  RUN deluser --remove-home halt
  RUN deluser --remove-home postmaster
  RUN deluser --remove-home cyrus
  RUN deluser --remove-home mail
  RUN deluser --remove-home news
  RUN deluser --remove-home uucp
  RUN deluser --remove-home operator
  RUN deluser --remove-home man
  RUN deluser --remove-home cron
  RUN deluser --remove-home ftp
  RUN deluser --remove-home sshd
  RUN deluser --remove-home at
  RUN deluser --remove-home squid
  RUN deluser --remove-home xfs
  RUN deluser --remove-home games
  RUN deluser --remove-home postgres
  RUN deluser --remove-home vpopmail
  RUN deluser --remove-home ntp
  RUN deluser --remove-home smmsp
  RUN deluser --remove-home guest
  RUN adduser -H -D ${USERNAME} -u ${USER_ID}
* RUN chown ${USERNAME}:${USERNAME} -R ${APPLICATION_PATH}
  USER app
  EXPOSE 3000
  VOLUME ["${APPLICATION_PATH}/pages"]
  ENTRYPOINT ["npm", "run", "dev"]
```

<!--v-->

### Collapse Directives

- every step in the Dockerfile builds a new image - we can never get smaller
- to reduce size, string up commands with `&&`
- `rm -rf` will finally see a downsizing of the image

<!--v-->

##### `\` and `&&`

```
  ARG ALPINE_VERSION=3.6
  FROM alpine:${ALPINE_VERSION}
  ARG APPLICATION_PATH=/app
* ENV APK_ADD="bash curl nodejs nodejs-npm yarn" \
*     APK_DEL="bash curl yarn" \
*     USERNAME="app" \
*     USER_ID="1000"
  WORKDIR ${APPLICATION_PATH}
  COPY . ${APPLICATION_PATH}
* RUN apk update \
*     && apk upgrade \
*     && apk add --no-cache ${APK_ADD} \
*     && yarn install \
*     && yarn build \
*     && yarn cache clean \
*     && rm -rf \
*         /usr/share/man/* \
*         /usr/includes/* \
*         /var/cache/apk/* \
*         /root/.npm/* \
*         /usr/lib/node_modules/npm/man/* \
*         /usr/lib/node_modules/npm/doc/* \
*         /usr/lib/node_modules/npm/html/* \
*         /usr/lib/node_modules/npm/scripts/* \
*     && apk del ${APK_DEL} \
*     && adduser -H -D ${USERNAME} -u ${USER_ID} \
*     && chown ${USERNAME}:${USERNAME} -R ${APPLICATION_PATH} \
*     && deluser --remove-home daemon \
*     && deluser --remove-home adm \
*     && deluser --remove-home lp \
*     && deluser --remove-home sync \
*     && deluser --remove-home shutdown \
*     && deluser --remove-home halt \
*     && deluser --remove-home postmaster \
*     && deluser --remove-home cyrus \
*     && deluser --remove-home mail \
*     && deluser --remove-home news \
*     && deluser --remove-home uucp \
*     && deluser --remove-home operator \
*     && deluser --remove-home man \
*     && deluser --remove-home cron \
*     && deluser --remove-home ftp \
*     && deluser --remove-home sshd \
*     && deluser --remove-home at \
*     && deluser --remove-home squid \
*     && deluser --remove-home xfs \
*     && deluser --remove-home games \
*     && deluser --remove-home postgres \
*     && deluser --remove-home vpopmail \
*     && deluser --remove-home ntp \
*     && deluser --remove-home smmsp \
*     && deluser --remove-home guest
  USER app
  EXPOSE 3000
  VOLUME ["${APPLICATION_PATH}/pages"]
  ENTRYPOINT ["npm", "run", "dev"]
```

<!--v-->

## Enhancements & Optimisations

- - -

#### Remove Useless Binaries & Artefacts

#### Secure Permissions

#### Remove Useless Users

#### Add Build-Time Configurations

#### Collapse Directives

- - -

<!--s-->

<!-- .slide: data-background="https://cdn.stocksnap.io/img-thumbs/960w/RIG6ID482D.jpg" -->
# Image Distribution

<!--v-->

### Specifying Metadata

- give users of your image a way to contact you if things go wrong
- do this via the `LABEL` directive

<!--v-->

### It was Me!

```
...
...
  FROM alpine:${ALPINE_VERSION}
* LABEL maintainer="zephinzer <dev@joeir.net>"
  ARG APPLICATION_PATH=/app
  ENV APK_ADD="bash curl nodejs nodejs-npm yarn" \
...
```

<!--v-->

### Image Licensing

- add the license as a LICENSE.md in your source code and let `COPY . ${APPLICATION_PATH}` work its magic
- choices, choices: [GPL](https://en.wikipedia.org/wiki/GNU_General_Public_License), [MIT](https://opensource.org/licenses/MIT), [UNLICENSE](https://unlicense.org/), [WTFPL](https://en.wikipedia.org/wiki/WTFPL)
- find a full list at: https://opensource.org/licenses/alphabetical

<!--v-->

### Publishing Image (Method 1)

##### To Docker Hub

> `docker push __author__/__repo__:__tag__`

<!--v-->

### Publishing Image (Method 2)

##### To Private Registry

`docker push __registry_url__/__author__/__repo__:__tag__`

<!--v-->

### Publishing Image (Method 3)

##### To `tar.gz`

`docker save -o image-tarball.tar.gz my_image`

<!--v-->

## Image Distribution

- - -

#### Specify Metadata

#### Image Licensing

#### Publishing The Image

- - -

<!--s-->

<!-- .slide: data-background="https://cdn.stocksnap.io/img-thumbs/960w/9TVI5AI6VF.jpg" -->
# Some Useful Stuff

<!--v-->

### Official Docker Repositories

- maintained by the Docker team
- supposedly exemplary Dockerfiles
- not optimised for specific use cases

> Link: [Official Docker Repositories](https://hub.docker.com/explore/)

<!--v-->

### If I was a bad presenter

- or if you want to go through this set of slides at your own pace
- check out the Medium article at: https://blog.gds-gov.tech/writing-effective-docker-images-more-efficiently-bf0129c3293b

<!--s-->

<!-- .slide: data-background="https://cdn.stocksnap.io/img-thumbs/960w/K51R58QJQB.jpg" -->
