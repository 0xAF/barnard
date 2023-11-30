# put this build script in the parent folder of the cloned repo

LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
srcdir=`pwd`
mkdir -p gopath/src/github.com/bmmcginty
ln -rTsf barnard gopath/src/github.com/bmmcginty/barnard
export GOPATH="${srcdir}/gopath"
cd gopath/src/github.com/bmmcginty/barnard
GO111MODULE=auto go get -v -d
#pushd "$srcdir/gopath/src/github.com/bmmcginty/go-openal"
#patch -N -p1 -i "$srcdir/1.patch"
#popd

cd "${srcdir}/gopath/src/github.com/bmmcginty/barnard"
GO111MODULE=auto go install \
  -gcflags "all=-trimpath=$GOPATH" \
  -asmflags "all=-trimpath=$GOPATH" \
  -ldflags "-extldflags $LDFLAGS" -v

