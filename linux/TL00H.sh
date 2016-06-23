#!/bin/bash
# @Author: 56304289@qq.com
# @Date: 2016.06.21
# @Last Modified by:   anchen
# @Last Modified time: 2016.06.19

echo "您打算从哪个版本开始查询（推荐从 40172 [B535] 开始）："
read v
echo "请输入结束查询的版本号:"
read e

Filter(){
    if [[ $1 == "1" ]]; then
        File="$PWD/TL00H/$i.xml"
        Size=`ls -il $File | awk '{print $6}'`
        if [ $Size == "162" ] || [ $Size == "107" ] || [ $Size == "0" ];then
            echo
            echo "This is Not to Download File, Will be Deleted!"
            echo "File:$File"
            echo "Size:$Size"
            rm $File
        fi
    else
        for f in `ls $PWD/TL00H`; do
            File=`ls -il $PWD/TL00H/$f | awk '{print $10}'`
            Size=`ls -il $PWD/TL00H/$f | awk '{print $6}'`
            if [ $Size == "162" ] || [ $Size == "0" ];then
                echo
                echo "This is Not to Download File, Will be Deleted!"
                echo "File:$File"
                echo "Size:$Size"
                rm $File
            fi
        done
    fi
}

Filter

GetCount=0
declare -i GetCount
MaxCount=100
declare -i MaxCount

for ((i=$v;i<$e;i++));do
    if [ $GetCount != $MaxCount ]; then
        echo
        echo "正在查询版本 v$i，若想终止直接关闭窗口"
        echo
        changelog_url="http://update.hicloud.com:8180/TDS/data/files/p3/s15/G1022/g223/v$i/f1/full/changelog.xml"
        curl $changelog_url > $PWD/TL00H/$i.xml

        Filter 1
        GetCount=GetCount+1
    else
        echo "Stop 30s"
        sleep 30
        GetCount=0
    fi
done

echo "可下载版本:"
#for xml in `find $PWD/TL00H`;do
#    vs=(`basename -s .xml $xml`)
#    vars=(${vs[*]})
#    echo "${vars[*]}"
#done

vs=(`find $PWD/TL00H -name *.xml`)
vars=(`basename -s .xml ${vs[*]}`)
echo "${vars[*]}"

echo "请输入要下载的版本:"
read var
echo "请选择下载工具: axel curl wget"
read d

update_url="http://update.hicloud.com:8180/TDS/data/files/p3/s15/G1022/g223/v$var/f1/full/update.zip"

Download(){
    if [ $1 == "axel" ];then
        if [ `which axel` ]; then
            axel -n 16 $update_url
        else
            echo "Not Install $1!"
        fi
    elif [ $1 == "curl" ];then
        if [ `which curl` ]; then
            curl $update_url
        else
            echo "Not Install $1!"
        fi
    elif [ $1 == "wget" ];then
        if [ `which wget` ]; then
            wget $update_url
        else
            echo "Not Install $1!"
        fi
    else
        echo "Not Install $1!"
    fi
}

case $d in
    "axel")
        Download $d
    ;;

    "curl")
        Download $d
    ;;

    "wget")
        Download $d
    ;;
    *)
        echo "Not Install $1!"
    ;;
esac
