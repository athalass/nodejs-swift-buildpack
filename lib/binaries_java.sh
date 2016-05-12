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