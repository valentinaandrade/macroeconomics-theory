% VERSION 2.0, MARCH 1997, COPYRIGHT H. UHLIG.
% WHATSNEW.M describes what is new in this version, which is version 2 of March 1997.


% Copyright: H. Uhlig.  Feel free to copy, modify and use at your own risk.
% However, you are not allowed to sell this software or otherwise impinge
% on its free distribution.

disp('These files are version 2 of my routines.');
disp('Their date is March 1997.');
disp('Compared to version 1 (i.e. the June 1995 version)');
disp('the following changes were made:');
disp('1) The procedure SOLVE.M has been made "smarter"');
disp('   For example, it can now deal with matrices Psi of reduced rank.');
disp('   If you had trouble solving your model before with solve.m,');
disp('   try it again with this updated version!  The procedure now uses a');
disp('   generalized eigenvalue procedure, suggested to me by Andrew Atkeson (thanks!).');
disp('   Also, it is now possible to select your favourite roots "manually".');
disp('   Type help solve for more instructions.');
disp('2) A routine called OPTIONS.M has been introduced');
disp('   where all the options for the other routines are set.');
disp('   OPTIONS.M is called by DO_IT.M, but needs to be');
disp('   called if any of the other routines is used in isolation.');
disp('   OPTIONS.M allows the manipulation of lots of stuff: type help options');
disp('   for more information.');
disp('3) A number of customization possibilities for all routines have been added.');
disp('   E.g. there are options for printing or saving graphs. Also,');
disp('   a routine called ENLARGE.M has been added that allows');
disp('   one to manipulate the plots by enlarging letter sizes for making slides, say.');
disp('   Type help impresp (and help enlarge) to see more instructions.');
disp('4) A number of examples have been added.  While example 0 and 1 are probably');
disp('   "standard examples", the other examples were just mainly added for didactical');
disp('   purposes.  Play with them and see whether they are useful for your work!');
disp('INCOMPATIBILITIES with version 1:');
disp('Standard usage of these programs should not run into problems with this update.');
disp('However, if you did some things "by hand" or did further calculations with some of');
disp('the intermediate results, read on:');
disp('1) If you want to call any of the routines in isolation');
disp('   (rather than via DO_IT.M), you now have to type');
disp('   options');
disp('   first at least once during your calculations to set the');
disp('   relevant options.  Before, they were directly set inside');
disp('   the individual routines.');
disp('2) In SOLVE.M, the definitions of Psi_mat, Theta_mat and');
disp('   Gamma_mat have been changed.  If you have somehow manipulated them further after');
disp('   their calculation with solve.m, you may get incompatibilities.');
disp(' ');
disp('   Harald Uhlig,  March 1997');
disp('   Tilburg University, uhlig@kub.nl, ');
disp('   Home page: http://cwis.kub.nl/~few5/center/STAFF/uhlig/home.htm');
disp('   You can get these files via: ');
disp('   http://cwis.kub.nl/~few5/center/STAFF/uhlig/toolkit.dir/toolkit.htm');