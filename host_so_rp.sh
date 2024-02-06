#!/bin/sh
echo "Setting Parameters"
program=sales_order_rp
userpass=`echo $1 | cut -f2 -d '"'`
user=`echo $userpass | cut -f1 -d '/'`
passwd=`echo $userpass | cut -f2 -d '/'`
reqid=`echo $1 | cut -f2 -d " " | cut -f2 -d "="`
usrid=`echo $1 | cut -f4 -d " " | cut -f2 -d "="`
### 

par1=`echo $1 | cut -f8 -d '"'`
par2=`echo $1 | cut -f10 -d '"'`
par3=`echo $1 | cut -f12 -d '"'`
par4=`echo $1 | cut -f14 -d '"'`
par5=`echo $1 | cut -f16 -d '"'`
par6=`echo $1 | cut -f18 -d '"'`
par7=`echo $1 | cut -f20 -d '"'`
par8=`echo $1 | cut -f22 -d '"'`
par9=`echo $1 | cut -f24 -d '"'`
par10=`echo $1 | cut -f26 -d '"'`
par11=`echo $1 | cut -f28 -d '"'`
par12=`echo $1 | cut -f30 -d '"'`

#echo userpass=$userpass
#echo user=$user passwd=$passwd
echo reqid=$reqid
###echo usrid=$usrid
echo "par1=$par1 par2=$par2 par3=$par3\n "

P_LOGIN=`echo $userpass `
P_REQID=`echo $reqid `
P_USERID=`echo $usrid `
P_USERNAME=`echo $user `
CTL_DIR=`echo $par1 `
CSV_DIR=`echo $par2 `
DATA_FILE=`echo $par3 `
LOG_FILE=`echo $par4 `
BAD_FILE=`echo $par5 `
DIS_FILE=`echo $par6 `
ARCH_PATH=`echo $par7 `

 echo "Script to copy the data file from output directory to the default directory. \n"
 echo "Created On: 2023 \n"

 echo "***************************** Parameter Listing *****************************\n"
 echo "Request Id                            : $P_REQID"
 #echo "Userid                               : $P_LOGIN"
 echo "Username                              : $P_USERNAME"
 echo "Control File with Directory           : $CTL_DIR"
 echo "CSV Directory                         : $CSV_DIR"
 echo "Data File Name                        : $DATA_FILE"
 echo "LOG FILE                              : $LOG_FILE"
 echo "BAD FILE                              : $BAD_FILE"
 echo "DIS FILE                              : $DIS_FILE"
 echo "ARCH Directory                        : $ARCH_PATH"
 echo "\n*****************************************************************************\n"

ldate='date +%d-%m-%Y:%T'

cd $CSV_DIR

for file in $DATA_FILE
do
echo $file
done

echo "File Name :$file"

if [ -s $file ]; 
then

echo "File Found and starting the sql load Process" 

sqlldr userid=$P_LOGIN control=$CTL_DIR log=$LOG_FILE data=$CSV_DIR/$file bad=$BAD_FILE discard=$DIS_FILE
echo "SQL*Loader execution successful" 

cd $CSV_DIR
cp $CSV_DIR/$file $ARCH_PATH/$file`$ldate`
rm $file  

echo "The data file has been copied successfully to the Archive Directory" 

else

echo "The data files doesn't exist in the directory or the file name has spaces.Please remove the spaces from the file name and retry again.." 

fi
