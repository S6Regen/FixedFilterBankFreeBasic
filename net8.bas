#include once "vecops10.bas"
#include once "xfile.bas"

type evonet
	veclen as ulongint
	depth as ulongint
	hash as ulongint
	weights(any) as single
	work(any) as single
    declare sub init(veclen as ulongint,depth as ulongint,hash as ulongint)
    declare sub recall(resultVec as single ptr,inVec as single ptr)
    declare sub sizememory()
    declare sub load()
    declare sub save()
end type

sub evonet.init(veclen as ulongint,depth as ulongint,hash as ulongint)
	this.veclen=2*veclen
	this.depth=depth
	this.hash=hash
	sizememory()
end sub

sub evonet.sizememory()
    redim weights(2*depth*veclen-1)
    redim work(veclen-1)
end sub

sub evonet.recall(resultVec as single ptr,inVec as single ptr)
	dim as ulongint half=veclen shr 1
    dim as single ptr wts=@weights(0),wa=@work(0)
	adjust(wa,inVec,.5*(1.7^depth),half) '1.7 to the power of depth. Scaling for switch subroutine
	copy(wa+half,wa,half)
	for i as ulongint=0 to depth-1
		   hashflip(wa,wa,hash+i,veclen)
		   whtq(wa,veclen)
		   switch(wa,wts,veclen):wts+=2*veclen
	next
	add(resultVec,wa,wa+half,half)
	whtq(resultVec,half)
	hashflip(resultVec,resultVec,not hash,half)
end sub

'save using xfile
sub evonet.save()
	xfile.save(veclen)
	xfile.save(depth)
	xfile.save(hash)
	xfile.save(weights())
end sub

sub evonet.load()
	xfile.load(veclen)
	xfile.load(depth)
	xfile.load(hash)
    sizememory()
    xfile.load(weights())
end sub
