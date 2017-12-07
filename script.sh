+#!/bin/bash


function datee {
            echo "-----------------------------";
            echo $(date);
            echo "-----------------------------";

		}
		
function move {
			cd /home/sansforensics/Desktop/Evidence-Locker/;
		}

function findlist {
		find . -type f ! -name '*.list'  -exec echo -n "sha1 : " \; -exec sha1sum {} \; -exec echo -n "md5 : " \; -exec md5sum {} \;   >> /home/sansforensics/Desktop/Evidence-Locker/findlist.list;
	}
	#
	
function findtype {
			find . -type f ! -name '*.list'  -exec file {} \; >> /home/sansforensics/Desktop/Evidence-Locker/filetype.list;
		}

function new {
			echo $'\n';
		}

	
	
mkdir /home/sansforensics/Desktop/Evidence-Locker/;
mkdir /home/sansforensics/Desktop/Evidence-Locker/md5;
mkdir /home/sansforensics/Desktop/Evidence-Locker/sha1;
sudo dd if=/dev/sdc of=/home/sansforensics/Desktop/image.dd bs=512;
new;
move;
cd ..;
sudo chmod 444 image.dd;
sha1sum image.dd > image.sha1;
md5sum image.dd > image.md5;


mv image.sha1 /home/sansforensics/Desktop/Evidence-Locker/;
mv image.md5 /home/sansforensics/Desktop/Evidence-Locker/;
md5sum image.dd > tmp.md5;
sha1sum image.dd > tmp.sha1;
DIFF=$(diff tmp.md5 /home/sansforensics/Desktop/Evidence-Locker/image.md5); 
if [ "$DIFF" != "" ] 
then
    echo "The md5 was modified when you moved the files... INTEGRITY LOST --> Mr Ovens will not be happy0";
else 
	echo "MD5 stayed the same when you moved the files, you are a CHAMP TIB"
fi


new;


DIFF=$(diff tmp.sha1 /home/sansforensics/Desktop/Evidence-Locker/image.sha1); 
if [ "$DIFF" != "" ] 
then
    echo "The SHA1 was modified when you moved the files... INTEGRITY LOST --> Mr Ovens will not be happy";
else 
	echo "The SHA1 stayed the same when you moved the files, you are a CHAMP TIB"
fi


rm tmp.*;

sudo mkdir /mnt/analysis;
sudo mount -t vfat -o ro,noexec,loop,offset=32256 image.dd /mnt/analysis;


new;


if [[ (! -f /home/sansforensics/Desktop/Evidence-Locker/list.list )&&
	  ( ! -f /home/sansforensics/Desktop/Evidence-Locker/findlist.list )&&
	  ( ! -f /home/sansforensics/Desktop/Evidence-Locker/filetype.list)]];

        then
                move;
                touch list.list;
                touch findlist.list;
                touch filetype.list;
		fi
              

	
    datee >> /home/sansforensics/Desktop/Evidence-Locker/list.list;
	datee >> /home/sansforensics/Desktop/Evidence-Locker/findlist.list;
    datee >> /home/sansforensics/Desktop/Evidence-Locker/filetype.list;
	cd /mnt/analysis;
    ls -aliRU -I list.list -I filetype.list -I findlist.list >> /home/sansforensics/Desktop/Evidence-Locker/list.list;
    findtype;
    findlist;
	move
	sha1sum findlist.list > findlist.sha1
	md5sum findlist.list > findlist.md5
	sha1sum filetype.list > filetype.sha1
	md5sum filetype.list > filetype.md5
	sha1sum list.list > list.sha1
	md5sum list.list > list.md5
	

	####

    
	cd ..;
	echo "allt-na-reigh" > searchlist.txt;	
	date > /home/sansforensics/Desktop/Evidence-Locker/searchresult.txt;
	grep -abif searchlist.txt image.dd > /home/sansforensics/Desktop/Evidence-Locker/searchresult.txt;
	
	mv searchlist.txt /home/sansforensics/Desktop/Evidence-Locker/;
	
	move;
	md5sum searchlist.txt > searchlist.md5
	sha1sum searchlist.txt > searchlist.sha1
	md5sum searchresult.txt > searchresult.md5	
	sha1sum searchresult.txt > searchresult.sha1
	echo " You can find 'allt-na-reigh' here :";
	new;
	cat searchresult.txt;
	
	new;

	


cd ..

fls -rpd image.dd -o 63 | grep -Eo " [0-9]+([^0-9]){0}" | sed -e 's/^\s*//' > unalocated-deleted.txt

mkdir /home/sansforensics/Desktop/Evidence-Locker/Files-unalocated-deleted
cat unalocated-deleted.txt | while read line;
do
ss=`ffind -o 63 image.dd $line | sed 's:.*/::'`;
echo "$ss was created under /home/sansforensics/Desktop/Evidence-Locker/Files-unalocated-deleted/$ss";
icat -o 63 image.dd $line > /home/sansforensics/Desktop/Evidence-Locker/Files-unalocated-deleted/$ss;
done;



rm unalocated-deleted.txt;
blkls -o 63 image.dd > /home/sansforensics/Desktop/Evidence-Locker/huna.blkls
blkls -o 63 -s image.dd > /home/sansforensics/Desktop/Evidence-Locker/slack.blkls



sudo fls -o63 -r -m "/" image.dd > /home/sansforensics/Desktop/Evidence-Locker/body #http://sysforensics.org/2012/03/sleuth-kit-part-3-fls-mactime-and-icat/
mactime -b body > /home/sansforensics/Desktop/Evidence-Locker/timline.txt 
move;

md5sum huna.blkls > huna.md5
sha1sum huna.blkls > huna.sha1
md5sum slack.blkls > slack.md5
sha1sum slack.blkls > slack.sha1
md5sum body > body.md5
sha1sum body >body.sha1
md5sum timline.txt > timline.md5
sha1sum timline.txt > timline.sha1

	mv *.sha1 sha1
	mv *.md5 md5
cd ..


mkdir /home/sansforensics/Desktop/Evidence-Locker/sorter/

	sudo sorter -d /home/sansforensics/Desktop/Evidence-Locker/sorter/ -o 63 -m "/" image.dd
	

for d in /home/sansforensics/Desktop/Evidence-Locker/sorter/*.*;
do
        echo $d 
        sha1sum $d > $d.sha1
        md5sum $d > $d.md5
done

cd /home/sansforensics/Desktop/Evidence-Locker/sorter/
mv *.md5 /home/sansforensics/Desktop/Evidence-Locker/md5
mv *.sha1 /home/sansforensics/Desktop/Evidence-Locker/sha1
