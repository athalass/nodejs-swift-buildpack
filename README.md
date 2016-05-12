# Custom Node.js with Apple's Swift Buildpack
[![CF Slack](https://s3.amazonaws.com/buildpacks-assets/buildpacks-slack.svg)](http://slack.cloudfoundry.org)

A Custom Buildpack [buildpack](http://docs.cloudfoundry.org/buildpacks/) for Node.js based apps with Apple's Swift installed.

Additionally, the Cloud Foundry CLI was included in the buildpack. 

This is based on the [Cloud Foundry buildpack](https://github.com/cloudfoundry/nodejs-buildpack) which is also based on the [Heroku buildpack](https://github.com/heroku/heroku-buildpack-nodejs).

Additional documentation can be found at the [CloudFoundry.org](http://docs.cloudfoundry.org/buildpacks/).

## Usage

This buildpack will get used if you have a `package.json` file in your project's root directory.

```bash
cf push my_app -b https://github.com/snippet-java/nodejs-swift-buildpack.git
```

In order to use Swift, Node.js needs to use child_process to compile and execute swift.


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

## How Apple's Swift Was Added?

The following script was added to the buildpack's compile script

```bash
 #binaries_swift.sh
install_swift() {
  local version="$1"
  local dir="$2"
  
  CLANG_VERSION=3.7.0
  SWIFT_VERSION=2.2.1-RELEASE
  SWIFT_VERSION_=2.2.1-release
  
  local download_url="http://llvm.org/releases/$CLANG_VERSION/clang+llvm-$CLANG_VERSION-x86_64-linux-gnu-ubuntu-14.04.tar.xz"
  echo "Downloading clang [$download_url]"
  curl  --silent --fail --retry 5 --retry-max-time 15 -j -k -L "$download_url" -o /tmp/clang.tar.xz || (echo "Unable to download clang; does it exist?" && false)
  echo "Download complete!"
    
  echo "Installing clang"
  mkdir -p /tmp/clang
  mkdir -p $dir/clang
  xz -d -c /tmp/clang.tar.xz | tar x -C /tmp/clang
  rm -rf $dir/clang/*
  mv /tmp/clang/clang+llvm-$CLANG_VERSION-x86_64-linux-gnu-ubuntu-14.04/* $dir/clang
  chmod +x $dir/clang/bin $dir/clang
  echo "Installation complete!"
  
  local download_url="https://swift.org/builds/swift-$SWIFT_VERSION_/ubuntu1404/swift-$SWIFT_VERSION/swift-$SWIFT_VERSION-ubuntu14.04.tar.gz"
  echo "Downloading Swift [$download_url]"
  curl  --silent --fail --retry 5 --retry-max-time 15 -j -k -L "$download_url" -o /tmp/swift.tar.gz || (echo "Unable to download swift; does it exist?" && false)
  echo "Download complete!"
  
  echo "Installing swift"
  mkdir -p /tmp/swift
  mkdir -p $dir
  tar xzf /tmp/swift.tar.gz -C /tmp/swift
  rm -rf $dir/*
  mv /tmp/swift/swift-$SWIFT_VERSION-ubuntu14.04/usr/* $dir
  chmod +x $dir/bin
  echo "Installation complete!"	
}
```

Then, PATH was set as well.

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
