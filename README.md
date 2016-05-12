# Custom Node.js with Oracle's JDK 8 Buildpack
[![CF Slack](https://s3.amazonaws.com/buildpacks-assets/buildpacks-slack.svg)](http://slack.cloudfoundry.org)

A Custom Buildpack [buildpack](http://docs.cloudfoundry.org/buildpacks/) for Node.js based apps with Oracle's JDK 8 installed.

Additionally, the Cloud Foundry CLI was included in the buildpack. 

This is based on the [Cloud Foundry buildpack](https://github.com/cloudfoundry/nodejs-buildpack) which is also based on the [Heroku buildpack](https://github.com/heroku/heroku-buildpack-nodejs).

Additional documentation can be found at the [CloudFoundry.org](http://docs.cloudfoundry.org/buildpacks/).

## Usage

This buildpack will get used if you have a `package.json` file in your project's root directory.

```bash
cf push my_app -b https://github.com/syahrul-aiman/nodejs-java-buildpack.git
```

In order to use Java, Node.js needs to use child_process and execute java command such as:
```bash
const exec = require('child_process').exec;
exec("java lib/HelloWorld.jar", {shell: '/bin/bash'}, function (err, stdout, stderr) {
	console.log(stderr);
	console.log(stdout);
});
```

Sample application:
[Node.js Java BeanShell Script Executer](https://github.com/syahrul-aiman/bluemix-nodejs-java-beanshell)

## Options

### Specify a node version

Set engines.node in package.json to the semver range
(or specific version) of node you'd like to use.
(It's a good idea to make this the same version you use during development)

```json
"engines": {
  "node": "0.11.x"
}
```

```json
"engines": {
  "node": "0.10.33"
}
```

## How Oracle's JDK 8 Was Added?

The following script was added to the buildpack's compile script

```bash
 #binaries_java.sh
install_java() {
  local version="$1"
  local dir="$2"
  
  local download_url="http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.tar.gz"
  echo "Downloading JAVA [$download_url]"
  curl  --silent --fail --retry 5 --retry-max-time 15 -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" "$download_url" -o /tmp/java.tar.gz || (echo "Unable to download java; does it exist?" && false)
  echo "Download complete!"

  echo "Installing JAVA"
  mkdir /tmp/jdk
  mkdir $dir
  tar xzf /tmp/java.tar.gz -C /tmp/jdk
  rm -rf $dir/*
  mv /tmp/jdk/jdk1.8.0_73/* $dir
  chmod +x $dir/bin
  echo "Installation complete!"	
}
```

Then, PATH and JAVA_HOME was set as well.

## How Cloud Foundry CLI Was Added?

The following script was added to the buildpack's compile script

```bash
 #binaries_cfcli.sh
install_cfcli() {
  local version="$1"
  local dir="$2"

  local download_url="https://cli.run.pivotal.io/stable?release=linux64-binary&source=github"
  echo "Downloading CF CLI [$download_url]"
  curl  --silent --fail --retry 5 --retry-max-time 15 -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" "$download_url" -o /tmp/cf.tar.gz || (echo "Unable to download cf CLI; does it exist?" && false)
  echo "Download complete!"

  echo "Installing CF CLI"
  tar xzf /tmp/cf.tar.gz -C $dir
  echo "Installation complete!"	
}
```

Then, PATH was set as well.


## Contributing

Find our guidelines [here](./CONTRIBUTING.md).


## Reporting Issues

Open an issue on this project
