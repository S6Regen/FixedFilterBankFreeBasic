#include once "vecops10.bas"
#include once "xfile.bas"

type evonet
	veclen as ulongint
	depth as ulongint
	hash as ulongint
	weights(any) as single
    declare sub init(veclen as ulongint,depth as ulongint,hash as ulongint)
    declare sub recall(resultVec as single ptr,inVec as single ptr)
    declare sub sizememory()
    declare sub load()
    declare sub save()
end type

sub evonet.init(veclen as ulongint,depth as ulongint,hash as ulongint)
	this.veclen=veclen
	this.depth=depth
	this.hash=hash
	sizememory()
end sub

sub evonet.sizememory()
    redim weights(2*depth*veclen-1)
end sub

sub evonet.recall(resultVec as single ptr,inVec as single ptr)
    dim as single ptr wts=@weights(0)
	adjust(resultVec,inVec,1.7^depth,veclen) '1.7 to the power of depth. Scaling for switch subroutine
	for i as ulongint=0 to depth-1
		   hashflip(resultVec,resultVec,hash+i,veclen)
		   whtq(resultVec,veclen)
		   switch(resultVec,wts,veclen):wts+=2*veclen
	next
	whtq(resultVec,veclen)
	hashflip(resultVec,resultVec,not hash,veclen)
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
