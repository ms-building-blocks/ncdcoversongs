% The cover song identification as presented in "Cross recurrence
% quantification for cover song identification" by Serra et al.
%
% input:
%
% output:
%
function ssa(target, query, outputfile, matdir, tpmat,sza)
% FIX SZA parameterzation!
% tarkista millä arvoilla on laskettu ja sillai!
% input ja output dokumentit sitten jostain toisesta systeemista
tic

tl = textread(target,'%s');
ql = textread(query,'%s');

qlen=size(ql,1);
tlen=size(tl,1);

load(tpmat);
klen=size(tposes,3);

dmat=zeros(qlen,tlen);

for ix=1:qlen
    disp(['Query ' num2str(ix)])
    qname=strrep(ql{ix},'gmats/',matdir);
    foo=load(qname);
    qdata=foo.data;
    for jx=1:tlen
        if (~mod(jx,50))
            disp(['  Target ' num2str(jx)])
        end
        tname=strrep(tl{jx},'gmats/',matdir);
        baz=load(tname);
        tdata=baz.data;
        dvalue=1;
        for kx=1:klen
            otivalue=tposes(ix,jx,kx);
            ttdata=circshift(tdata,otivalue);
            kdist=ssadist(qdata,ttdata,9,1,0.1,0.5,0.5,false); % SSA
            %kdist=ssadist(qdata,ttdata,9,1,0.1,0.5,0.5,true); % SZA
            if (kdist<dvalue)
                dvalue=kdist;
            end
        end
        dmat(ix,jx)=dvalue;
    end
end

save(outputfile,'-ascii','dmat')
toc
end
