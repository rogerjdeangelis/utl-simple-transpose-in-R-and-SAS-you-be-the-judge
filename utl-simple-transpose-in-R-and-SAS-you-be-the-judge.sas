SAS Forum: Simple transpose in R and SAS you be the judge

 Normalize a matrix keeping just ;Y' values

     Two Solutions

           a. R  (gather function might work better? - need shared memory with SAS?)
           b. SAS


github
https://tinyurl.com/sy3mczq
https://github.com/rogerjdeangelis/utl-simple-transpose-in-R-and-SAS-you-be-the-judge

stackoverflow
https://tinyurl.com/yx767xg9
https://stackoverflow.com/questions/59542504/how-to-match-row-to-column-when-yes-is-entered-in-multiple-columns

Sotos
https://stackoverflow.com/users/5635580/sotos

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

options validvarname=upcase;
data sd1.have;
  input (ID X1-X7) ($2.);
cards4;
A Y N Y N Y N N
B Y N N N N N N
C N N N Y Y N N
D N N N N N N Y
E N Y N N N N N
F N N N N N N N
G N N N N N N N
H N N Y N N N N
I N N N N N N N
J Y N N Y N N N
;;;;
run;quit;

 SD1.HAVE total obs=10

   ID    X1    X2    X3    X4    X5    X6    X7

   A     Y     N     Y     N     Y     N     N
   B     Y     N     N     N     N     N     N
   C     N     N     N     Y     Y     N     N
   D     N     N     N     N     N     N     Y
   E     N     Y     N     N     N     N     N
   F     N     N     N     N     N     N     N
   G     N     N     N     N     N     N     N
   H     N     N     Y     N     N     N     N
   I     N     N     N     N     N     N     N
   J     Y     N     N     Y     N     N     N

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
 ___  __ _ ___  |_|
/ __|/ _` / __|
\__ \ (_| \__ \
|___/\__,_|___/

;
WORK.WANT total obs=11

  ID    _NAME_    COL1

  A       X1       Y   ** only Ys
  A       X3       Y
  A       X5       Y
  B       X1       Y
  C       X4       Y
  C       X5       Y
  D       X7       Y
  E       X2       Y
  H       X3       Y
  J       X1       Y
  J       X4       Y

*____
|  _ \
| |_) |
|  _ <
|_| \_\

;

WORK.WANT total obs=11

   ID    VALUES

   A       Y
   B       Y
   J       Y
   E       Y
   A       Y
   H       Y
   C       Y
   J       Y
   A       Y
   C       Y
   D       Y

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/
           ____
  __ _    |  _ \
 / _` |   | |_) |
| (_| |_  |  _ <
 \__,_(_) |_| \_\

;
proc datasets lib=work;
 delete want;
run;quit;

%utlfkil(d:/xpt/want.xpt);

%utl_submit_r64('
library(haven);
library(SASxport);
have<-read_sas("d:/sd1/have.sas7bdat");
want<-na.omit(cbind.data.frame(have[1], stack(replace(have, have == "N", NA)[-1])));
write.xport(want,file="d:/xpt/want.xpt");
');

libname xpt xport "d:/xpt/want.xpt";
data want;
  set xpt.want(drop=ind);
run;quit;
libname xpt clear;

*_
| |__     ___  __ _ ___
| '_ \   / __|/ _` / __|
| |_) |  \__ \ (_| \__ \
|_.__(_) |___/\__,_|___/

;

proc transpose data=sd1.have out=want(where=(col1='Y'));
  by id;
  var x1-x7;
run;quit;


