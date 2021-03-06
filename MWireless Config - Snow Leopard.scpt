FasdUAS 1.101.10   ��   ��    k             l      ��  ��   	A	;**** Wireless Auth Config Leopard.scpt ************************************* This script simplifies the process of configuring a computer to connect to the MWireless network.  Primarily, its function is to install two certificates into the computer's keychains and to install an 802.1X configuration for establishing the wireless connection.This script is based on a Leopard-only version from December 2009.  Several routines and much code from that version were changed for this Snow Leopard-only version.  For an in-depth version history, see that script.NOTE:  This script requires Mac OS X 10.6.2 ("Snow Leopard") or later.***** Version History: *************************************************
2010-02-10		chaimk
� Added keys 'UserPasswordKeychainItemID' & 'UniqueIdentifier' to default MWireless profile in the configure8021X() handler.

2010-01-24		chaimk
� Added key 'OneTimeUserPassword' to default MWireless profile in the configure8021X() handler.

2010-01-12		chaimk
� Initial Snow Leopard version
� ncutil is no longer required now that we have the fully functional cl command 'networksetup' (finally an OS-native method for accessing the SystemConfiguration database...), so all code that installs and utilizes ncutil have been removed
� Added the 'setPreferredNetwork()' handler to set MWireless as the top preferred AirPort network (meaning, the computer should use that AirPort network first whenever it becomes available).  This is a longstanding request of Walt's.  This is accomplished using new (in Snow Leopard) commands in the cl utility 'networksetup'.

2009-12-21		chaimk
� In testing, it became apparent that we canNOT assume that bsd-device 'en1' is AirPort.  MacBook Airs, for example, have no on-board ethernet, so en0 is AirPort.  And there are other variations as well.  So now the 'setPreferredNetwork()' handler does not assume en1 as the AirPort device name but rather uses the cl command 'networksetup' to retrieve it.

2009-11-30		chaimk

2009-10-27		chaimk
� Fixed a bug noted in an online.consulting message (Footprints ticket #270888) regarding an unexpected error message: 'A fatal error occurred. -1728: Can't get |Wireless Network| of "UMTRI-Wireless"'.  This was fixed in 'configure8021X()' by inserting the code in question into a try block.
******************************************************************     � 	 	v * * * *   W i r e l e s s   A u t h   C o n f i g   L e o p a r d . s c p t   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *     T h i s   s c r i p t   s i m p l i f i e s   t h e   p r o c e s s   o f   c o n f i g u r i n g   a   c o m p u t e r   t o   c o n n e c t   t o   t h e   M W i r e l e s s   n e t w o r k .     P r i m a r i l y ,   i t s   f u n c t i o n   i s   t o   i n s t a l l   t w o   c e r t i f i c a t e s   i n t o   t h e   c o m p u t e r ' s   k e y c h a i n s   a n d   t o   i n s t a l l   a n   8 0 2 . 1 X   c o n f i g u r a t i o n   f o r   e s t a b l i s h i n g   t h e   w i r e l e s s   c o n n e c t i o n .   T h i s   s c r i p t   i s   b a s e d   o n   a   L e o p a r d - o n l y   v e r s i o n   f r o m   D e c e m b e r   2 0 0 9 .     S e v e r a l   r o u t i n e s   a n d   m u c h   c o d e   f r o m   t h a t   v e r s i o n   w e r e   c h a n g e d   f o r   t h i s   S n o w   L e o p a r d - o n l y   v e r s i o n .     F o r   a n   i n - d e p t h   v e r s i o n   h i s t o r y ,   s e e   t h a t   s c r i p t .   N O T E :     T h i s   s c r i p t   r e q u i r e s   M a c   O S   X   1 0 . 6 . 2   ( " S n o w   L e o p a r d " )   o r   l a t e r .   * * * * *   V e r s i o n   H i s t o r y :   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 2 0 1 0 - 0 2 - 1 0 	 	 c h a i m k 
 "   A d d e d   k e y s   ' U s e r P a s s w o r d K e y c h a i n I t e m I D '   &   ' U n i q u e I d e n t i f i e r '   t o   d e f a u l t   M W i r e l e s s   p r o f i l e   i n   t h e   c o n f i g u r e 8 0 2 1 X ( )   h a n d l e r . 
 
 2 0 1 0 - 0 1 - 2 4 	 	 c h a i m k 
 "   A d d e d   k e y   ' O n e T i m e U s e r P a s s w o r d '   t o   d e f a u l t   M W i r e l e s s   p r o f i l e   i n   t h e   c o n f i g u r e 8 0 2 1 X ( )   h a n d l e r . 
 
 2 0 1 0 - 0 1 - 1 2 	 	 c h a i m k 
 "   I n i t i a l   S n o w   L e o p a r d   v e r s i o n 
 "   n c u t i l   i s   n o   l o n g e r   r e q u i r e d   n o w   t h a t   w e   h a v e   t h e   f u l l y   f u n c t i o n a l   c l   c o m m a n d   ' n e t w o r k s e t u p '   ( f i n a l l y   a n   O S - n a t i v e   m e t h o d   f o r   a c c e s s i n g   t h e   S y s t e m C o n f i g u r a t i o n   d a t a b a s e . . . ) ,   s o   a l l   c o d e   t h a t   i n s t a l l s   a n d   u t i l i z e s   n c u t i l   h a v e   b e e n   r e m o v e d 
 "   A d d e d   t h e   ' s e t P r e f e r r e d N e t w o r k ( ) '   h a n d l e r   t o   s e t   M W i r e l e s s   a s   t h e   t o p   p r e f e r r e d   A i r P o r t   n e t w o r k   ( m e a n i n g ,   t h e   c o m p u t e r   s h o u l d   u s e   t h a t   A i r P o r t   n e t w o r k   f i r s t   w h e n e v e r   i t   b e c o m e s   a v a i l a b l e ) .     T h i s   i s   a   l o n g s t a n d i n g   r e q u e s t   o f   W a l t ' s .     T h i s   i s   a c c o m p l i s h e d   u s i n g   n e w   ( i n   S n o w   L e o p a r d )   c o m m a n d s   i n   t h e   c l   u t i l i t y   ' n e t w o r k s e t u p ' . 
 
 2 0 0 9 - 1 2 - 2 1 	 	 c h a i m k 
 "   I n   t e s t i n g ,   i t   b e c a m e   a p p a r e n t   t h a t   w e   c a n N O T   a s s u m e   t h a t   b s d - d e v i c e   ' e n 1 '   i s   A i r P o r t .     M a c B o o k   A i r s ,   f o r   e x a m p l e ,   h a v e   n o   o n - b o a r d   e t h e r n e t ,   s o   e n 0   i s   A i r P o r t .     A n d   t h e r e   a r e   o t h e r   v a r i a t i o n s   a s   w e l l .     S o   n o w   t h e   ' s e t P r e f e r r e d N e t w o r k ( ) '   h a n d l e r   d o e s   n o t   a s s u m e   e n 1   a s   t h e   A i r P o r t   d e v i c e   n a m e   b u t   r a t h e r   u s e s   t h e   c l   c o m m a n d   ' n e t w o r k s e t u p '   t o   r e t r i e v e   i t . 
 
 2 0 0 9 - 1 1 - 3 0 	 	 c h a i m k 
  
 2 0 0 9 - 1 0 - 2 7 	 	 c h a i m k 
 "   F i x e d   a   b u g   n o t e d   i n   a n   o n l i n e . c o n s u l t i n g   m e s s a g e   ( F o o t p r i n t s   t i c k e t   # 2 7 0 8 8 8 )   r e g a r d i n g   a n   u n e x p e c t e d   e r r o r   m e s s a g e :   ' A   f a t a l   e r r o r   o c c u r r e d .   - 1 7 2 8 :   C a n ' t   g e t   | W i r e l e s s   N e t w o r k |   o f   " U M T R I - W i r e l e s s " ' .     T h i s   w a s   f i x e d   i n   ' c o n f i g u r e 8 0 2 1 X ( ) '   b y   i n s e r t i n g   t h e   c o d e   i n   q u e s t i o n   i n t o   a   t r y   b l o c k . 
  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *   
  
 l     ��������  ��  ��        l     ��������  ��  ��        j     �� �� <0 mwirelessappsupportdirectory mwirelessAppSupportDirectory  m        �   b / L i b r a r y / A p p l i c a t i o n   S u p p o r t / U - M   S e c u r e   W i r e l e s s /      j    �� �� $0 uniqueidentifier uniqueIdentifier  m       �   H F 5 7 6 A C 6 3 - 1 A E 3 - 4 A 6 7 - B 8 9 0 - 1 0 9 E 8 A B 3 C 1 8 9      j    �� �� :0 sysconfigprefsplistfilepath sysconfigPrefsPlistFilePath  m       �   t / L i b r a r y / P r e f e r e n c e s / S y s t e m C o n f i g u r a t i o n / p r e f e r e n c e s . p l i s t      l         !  p   	 	 " " ������ 0 bdlib bdLib��     / ) The Blue Disc AppleScript Library object    ! � # # R   T h e   B l u e   D i s c   A p p l e S c r i p t   L i b r a r y   o b j e c t   $ % $ l      & ' ( & p   	 	 ) ) ������ 0 uniqnamelib uniqnameLib��   ' . ( The uniqname AppleScript Library object    ( � * * P   T h e   u n i q n a m e   A p p l e S c r i p t   L i b r a r y   o b j e c t %  + , + l      - . / - p   	 	 0 0 ������ 0 sysinfo sysInfo��   . a [ The System Info object containing routines for gathering the computer's system information    / � 1 1 �   T h e   S y s t e m   I n f o   o b j e c t   c o n t a i n i n g   r o u t i n e s   f o r   g a t h e r i n g   t h e   c o m p u t e r ' s   s y s t e m   i n f o r m a t i o n ,  2 3 2 l      4 5 6 4 p   	 	 7 7 ������ .0 ethernetmacaddrstring ethernetMACaddrString��   5 F @ Main Ethernet MAC address for the computer (stripped of colons)    6 � 8 8 �   M a i n   E t h e r n e t   M A C   a d d r e s s   f o r   t h e   c o m p u t e r   ( s t r i p p e d   o f   c o l o n s ) 3  9 : 9 p   	 	 ; ; ������ 0 uniqname  ��   :  < = < p   	 	 > > ������ &0 airportdevicename airPortDeviceName��   =  ? @ ? p   	 	 A A ������  0 airportmacaddr airPortMACaddr��   @  B C B l     ��������  ��  ��   C  D E D i   	  F G F I     ������
�� .aevtoappnull  �   � ****��  ��   G k    Z H H  I J I I    ������
�� .miscactvnull��� ��� null��  ��   J  K L K l   ��������  ��  ��   L  M N M l   �� O P��   O n h Must load the Blue Disc Library of AppleScript classes containing most of the routines for this script:    P � Q Q �   M u s t   l o a d   t h e   B l u e   D i s c   L i b r a r y   o f   A p p l e S c r i p t   c l a s s e s   c o n t a i n i n g   m o s t   o f   t h e   r o u t i n e s   f o r   t h i s   s c r i p t : N  R S R Q    I T U V T r   	  W X W I  	 �� Y��
�� .sysoloadscpt        file Y l  	  Z���� Z c   	  [ \ [ l  	  ]���� ] b   	  ^ _ ^ l  	  `���� ` I  	 �� a b
�� .earsffdralis        afdr a m   	 
��
�� afdrasup b �� c d
�� 
from c m    ��
�� fldmfldl d �� e��
�� 
rtyp e m    ��
�� 
ctxt��  ��  ��   _ m     f f � g g N U - M   B l u e   D i s c : S c r i p t s : U M B l u e D i s c L i b . a p p��  ��   \ m    ��
�� 
alis��  ��  ��   X o      ���� 0 bdlib bdLib U R      �� h i
�� .ascrerr ****      � **** h o      ���� 0 	errstring 	errString i �� j��
�� 
errn j o      ���� 0 	errnumber 	errNumber��   V I  $ I�� k l
�� .sysodisAaleR        TEXT k m   $ % m m � n n J U n a b l e   t o   l o a d   t h e   B l u e   D i s c   l i b r a r y . l �� o p
�� 
mesS o b   & 1 q r q b   & / s t s b   & + u v u m   & ) w w � x x ^ W i r e l e s s   c o n f i g u r a t i o n   i s   u n a b l e   t o   c o n t i n u e .     v o   ) *���� 0 	errstring 	errString t m   + . y y � z z    E r r o r   r o   / 0���� 0 	errnumber 	errNumber p �� { |
�� 
as A { m   4 7��
�� EAlTcriT | �� } ~
�� 
btns } J   : ?    ��� � m   : = � � � � �  Q u i t��   ~ �� ���
�� 
cbtn � m   B C���� ��   S  � � � l  J J��������  ��  ��   �  � � � l  J J�� � ���   � $  Create the systemInfo object:    � � � � <   C r e a t e   t h e   s y s t e m I n f o   o b j e c t : �  � � � O  J X � � � r   N W � � � I   N S�������� ,0 makeobjectsysteminfo makeObjectSystemInfo��  ��   � o      ���� 0 sysinfo sysInfo � o   J K���� 0 bdlib bdLib �  � � � l  Y Y��������  ��  ��   �  � � � l  Y Y�� � ���   � l f Load the uniqname library of AppleScript classes containing routines for getting the user's uniqname:    � � � � �   L o a d   t h e   u n i q n a m e   l i b r a r y   o f   A p p l e S c r i p t   c l a s s e s   c o n t a i n i n g   r o u t i n e s   f o r   g e t t i n g   t h e   u s e r ' s   u n i q n a m e : �  � � � Q   Y � � � � � r   \ s � � � I  \ o�� ���
�� .sysoloadscpt        file � l  \ k ����� � c   \ k � � � l  \ i ����� � b   \ i � � � l  \ e ����� � I  \ e�� � �
�� .earsffdralis        afdr � m   \ ]��
�� afdrasup � �� � �
�� 
from � m   ^ _��
�� fldmfldl � �� ���
�� 
rtyp � m   ` a��
�� 
ctxt��  ��  ��   � m   e h � � � � � V U - M   B l u e   D i s c : S c r i p t s : u n i q n a m e A c c e s s L i b . a p p��  ��   � m   i j��
�� 
alis��  ��  ��   � o      ���� 0 uniqnamelib uniqnameLib � R      �� � �
�� .ascrerr ****      � **** � o      ���� 0 	errstring 	errString � �� ���
�� 
errn � o      ���� 0 	errnumber 	errNumber��   � I  { ��� � �
�� .sysodisAaleR        TEXT � m   { ~ � � � � � t S c r i p t   l i b r a r y   " u n i q n a m e A c c e s s L i b . a p p "   c o u l d   n o t   b e   f o u n d . � �� � �
�� 
mesS � b    � � � � b    � � � � b    � � � � m    � � � � � � ^ W i r e l e s s   c o n f i g u r a t i o n   i s   u n a b l e   t o   c o n t i n u e .     � o   � ����� 0 	errstring 	errString � m   � � � � � � �    E r r o r   � o   � ����� 0 	errnumber 	errNumber � �� � �
�� 
as A � m   � ���
�� EAlTcriT � �� � �
�� 
btns � J   � � � �  ��� � m   � � � � � � �  Q u i t��   � �� ���
�� 
cbtn � m   � ����� ��   �  � � � l  � ���������  ��  ��   �  � � � Q   �X � � � � k   �) � �  � � � l  � ��� � ���   � N H Make sure that client computer has Mac OS X 10.6.2 and an AirPort card:    � � � � �   M a k e   s u r e   t h a t   c l i e n t   c o m p u t e r   h a s   M a c   O S   X   1 0 . 6 . 2   a n d   a n   A i r P o r t   c a r d : �  � � � I   � ��������� $0 validatecomputer validateComputer��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � g a Gather various settings (uniqname, MAC addresses, hardware device names for ethernet & AirPort):    � � � � �   G a t h e r   v a r i o u s   s e t t i n g s   ( u n i q n a m e ,   M A C   a d d r e s s e s ,   h a r d w a r e   d e v i c e   n a m e s   f o r   e t h e r n e t   &   A i r P o r t ) : �  � � � I   � ���~�}�  0 gathersettings gatherSettings�~  �}   �  � � � l  � ��|�{�z�|  �{  �z   �  � � � l  � ��y � ��y   � : 4  Change the EAP trust setting for the Entrust cert:    � � � � h     C h a n g e   t h e   E A P   t r u s t   s e t t i n g   f o r   t h e   E n t r u s t   c e r t : �  � � � I   � ��x�w�v�x 00 changeentrustcerttrust changeEntrustCertTrust�w  �v   �  � � � l  � ��u�t�s�u  �t  �s   �  � � � l  � ��r � ��r   � 4 . Create and configure an 802.1X configuration:    � � � � \   C r e a t e   a n d   c o n f i g u r e   a n   8 0 2 . 1 X   c o n f i g u r a t i o n : �  � � � I   � ��q�p�o�q  0 configure8021x configure8021X�p  �o   �  � � � l  � ��n�m�l�n  �m  �l   �  � � � l  � ��k � ��k   � @ : Place MWireless at the top of the preferred network list:    � � � � t   P l a c e   M W i r e l e s s   a t   t h e   t o p   o f   t h e   p r e f e r r e d   n e t w o r k   l i s t : �  � � � Q   � � � � � � I   � ��j�i�h�j *0 setpreferrednetwork setPreferredNetwork�i  �h   � R      �g�f�e
�g .ascrerr ****      � ****�f  �e   � I  � ��d 
�d .sysodisAaleR        TEXT  m   � � � � A   m i n o r   e r r o r   o c c u r r e d   w h e n   a t t e m p t i n g   t o   i n s e r t   " M W i r e l e s s "   i n t o   t h e   P r e f e r r e d   N e t w o r k s   l i s t . �c
�c 
mesS m   � � �6 I f   " M W i r e l e s s "   i s   n o t   i n   y o u r   P r e f e r r e d   N e t w o r k s   l i s t ,   y o u   w i l l   e i t h e r   h a v e   t o   m a n u a l l y   i n s e r t   i t   i n t o   t h e   P r e f e r r e d   N e t w o r k s   l i s t ,   o r   e a c h   t i m e   y o u   c o n n e c t   t o   M W i r e l e s s   y o u   w i l l   h a v e   t o   m a n u a l l y   c h o o s e   i t   f r o m   t h e   A i r P o r t   m e n u .     I n   a n y   c a s e ,   y o u   w i l l   s t i l l   b e   a b l e   t o   u s e   M W i r e l e s s . �b	
�b 
as A m   � ��a
�a EAlTwarN	 �`

�` 
btns
 J   � � �_ m   � � �  O K�_   �^�]
�^ 
dflt m   � ��\�\ �]   �  l  � ��[�Z�Y�[  �Z  �Y    l  � ��X�X   = 7 Activate the AirPort menu if it is not active already:    � n   A c t i v a t e   t h e   A i r P o r t   m e n u   i f   i t   i s   n o t   a c t i v e   a l r e a d y :  O  � I  � �W�V
�W .aevtodocnull  �    alis 4   � ��U
�U 
psxf m   � � � j / S y s t e m / L i b r a r y / C o r e S e r v i c e s / M e n u   E x t r a s / A i r P o r t . m e n u�V   m   � �  �                                                                                  MACS  alis    n  Main Volume                ��MNH+   ���
Finder.app                                                      �k�Ƙv        ����  	                CoreServices    ��#      ƘK�     ��� ��F ��E  2Main Volume:System:Library:CoreServices:Finder.app   
 F i n d e r . a p p    M a i n   V o l u m e  &System/Library/CoreServices/Finder.app  / ��   !"! l �T�S�R�T  �S  �R  " #$# I �Q�P�O
�Q .miscactvnull��� ��� null�P  �O  $ %&% I '�N'(
�N .sysodisAaleR        TEXT' m  )) �** h Y o u r   c o m p u t e r   i s   r e a d y   t o   u s e   t h e   M W i r e l e s s   n e t w o r k .( �M+,
�M 
mesS+ m  -- �.. T o   u s e   t h e   M W i r e l e s s   n e t w o r k ,   p o i n t   y o u r   m o u s e   a t   t h e   A i r P o r t   m e n u   i n   t h e   u p p e r - r i g h t   p o r t i o n   o f   y o u r   s c r e e n   a n d   s e l e c t   " M W i r e l e s s " ., �L/0
�L 
as A/ m  �K
�K EAlTinfA0 �J12
�J 
btns1 J  33 4�I4 m  55 �66  O K�I  2 �H7�G
�H 
dflt7 m   !�F�F �G  & 8�E8 l ((�D�C�B�D  �C  �B  �E   � R      �A9:
�A .ascrerr ****      � ****9 o      �@�@ 0 	errstring 	errString: �?;�>
�? 
errn; o      �=�= 0 	errnumber 	errNumber�>   � I 1X�<<=
�< .sysodisAaleR        TEXT< m  14>> �?? . A   f a t a l   e r r o r   o c c u r r e d .= �;@A
�; 
mesS@ b  5@BCB b  5>DED l 5:F�:�9F c  5:GHG o  56�8�8 0 	errnumber 	errNumberH m  69�7
�7 
TEXT�:  �9  E m  :=II �JJ  :  C o  >?�6�6 0 	errstring 	errStringA �5KL
�5 
as AK m  CF�4
�4 EAlTcriTL �3MN
�3 
btnsM J  INOO P�2P m  ILQQ �RR  Q u i t�2  N �1S�0
�1 
cbtnS m  QR�/�/ �0   � T�.T l YY�-�,�+�-  �,  �+  �.   E UVU l     �*�)�(�*  �)  �(  V WXW l     �'�&�%�'  �&  �%  X YZY l      �$[\�$  [ � �***************************************************
validateComputer(): Make sure that client computer has Mac OS X 10.6.2 and an AirPort card
***************************************************   \ �]]� * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 v a l i d a t e C o m p u t e r ( ) :   M a k e   s u r e   t h a t   c l i e n t   c o m p u t e r   h a s   M a c   O S   X   1 0 . 6 . 2   a n d   a n   A i r P o r t   c a r d 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *Z ^_^ l     �#�"�!�#  �"  �!  _ `a` i   bcb I      � ���  $0 validatecomputer validateComputer�  �  c k     �dd efe l     �gh�  g P J Verify that the script is being run under Mac OS X 10.6.2 or higher only:   h �ii �   V e r i f y   t h a t   t h e   s c r i p t   i s   b e i n g   r u n   u n d e r   M a c   O S   X   1 0 . 6 . 2   o r   h i g h e r   o n l y :f jkj P     Elm�l Z    Dno��n A    pqp n   
rsr I    
���� 0 getosversion getOSVersion�  �  s o    �� 0 sysinfo sysInfoq m   
 tt �uu  1 0 . 6 . 2o k    @vv wxw I   �yz
� .sysodlogaskr        TEXTy m    {{ �||� Y o u   m u s t   b e   r u n n i n g   M a c   O S   X   1 0 . 6 . 2   o r   h i g h e r     ( a k a   " S n o w   L e o p a r d " )   t o   u s e   t h i s   s c r i p t .     Y o u   c a n   m a n u a l l y   c o n f i g u r e   y o u r   c o m p u t e r   f o r   t h e   M W i r e l e s s   N e t w o r k   b y   r e a d i n g   t h i s   d o c u m e n t :   h t t p : / / w w w . i t c o m . i t c s . u m i c h . e d u / w i r e l e s s / m w i r e l e s s / m a c - o s . h t m lz �}~
� 
btns} J     ��� m    �� ���  C a n c e l� ��� m    �� ���  G o   t o   d o c u m e n t�  ~ ���
� 
dflt� m    �� ���  G o   t o   d o c u m e n t� ���
� 
disp� m    �
� stic    �  x ��� Z   3����� =   %��� n    !��� 1    !�
� 
bhit� 1    �
� 
rslt� m   ! $�� ���  G o   t o   d o c u m e n t� I  ( /�
��	
�
 .GURLGURLnull��� ��� TEXT� m   ( +�� ��� | h t t p : / / w w w . i t c o m . i t c s . u m i c h . e d u / w i r e l e s s / m w i r e l e s s / m a c - o s . h t m l�	  �  �  � ��� R   4 @���
� .ascrerr ****      � ****� m   < ?�� ��� � T h e   v e r s i o n   o f   M a c   O S   X   c u r r e n t l y   r u n n i n g   o n   t h i s   c o m p u t e r   i s   i n c o m p a t i b l e   w i t h   t h i s   i n s t a l l e r .� ���
� 
errn� m   8 ;�����  �  �  �  m ��
� consnume�  �  k ��� l  F F�� ���  �   ��  � ��� l  F F������  � G A Before proceeding, check if AirPort even exists on the computer:   � ��� �   B e f o r e   p r o c e e d i n g ,   c h e c k   i f   A i r P o r t   e v e n   e x i s t s   o n   t h e   c o m p u t e r :� ��� O   F a��� O   L `��� r   T _��� l  T ]������ n   T ]��� 1   Y ]��
�� 
pnam� 2   T Y��
�� 
intf��  ��  � o      ���� 0 interfacelist interfaceList� 1   L Q��
�� 
netp� m   F I���                                                                                  sevs  alis    �  Main Volume                ��MNH+   ���System Events.app                                               �
��8Qg        ����  	                CoreServices    ��#      �8'7     ��� ��F ��E  9Main Volume:System:Library:CoreServices:System Events.app   $  S y s t e m   E v e n t s . a p p    M a i n   V o l u m e  -System/Library/CoreServices/System Events.app   / ��  � ���� Z   b �������� H   b h�� E   b g��� o   b c���� 0 interfacelist interfaceList� m   c f�� ���  A i r P o r t� k   k ��� ��� I  k p�����
�� .sysobeepnull��� ��� long� m   k l���� ��  � ���� I  q �����
�� .sysodisAaleR        TEXT� m   q t�� ��� r Y o u r   c o m p u t e r   d o e s   n o t   a p p e a r   t o   c o n t a i n   a n   A i r P o r t   c a r d .� ����
�� 
mesS� m   w z�� ��� Z W i r e l e s s   c o n f i g u r a t i o n   i s   u n a b l e   t o   c o n t i n u e .� ����
�� 
as A� m   } ���
�� EAlTcriT� ����
�� 
btns� J   � ��� ���� m   � ��� ���  Q u i t��  � �����
�� 
cbtn� m   � ����� ��  ��  ��  ��  ��  a ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l      ������  � � �***************************************************gatherSettings: Gather various settings (uniqname, MAC addresses, hardware device names for ethernet & AirPort)
***************************************************   � ���� * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  g a t h e r S e t t i n g s :   G a t h e r   v a r i o u s   s e t t i n g s   ( u n i q n a m e ,   M A C   a d d r e s s e s ,   h a r d w a r e   d e v i c e   n a m e s   f o r   e t h e r n e t   &   A i r P o r t ) 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *� ��� l     ��������  ��  ��  � ��� i   ��� I      ��������  0 gathersettings gatherSettings��  ��  � k     ��� ��� l     ��������  ��  ��  � ��� l     ������  � R L Get the uniqname; strictly limit the uniqname to 3-8 alphabetic characters:   � ��� �   G e t   t h e   u n i q n a m e ;   s t r i c t l y   l i m i t   t h e   u n i q n a m e   t o   3 - 8   a l p h a b e t i c   c h a r a c t e r s :� ��� l    ���� O    ��� r    ��� I    	�������� 0 getuserinfo getUserInfo��  ��  � o      ���� 0 uniqname  � o     ���� 0 uniqnamelib uniqnameLib� 1 + gets uniqname from file or from user input   � ��� V   g e t s   u n i q n a m e   f r o m   f i l e   o r   f r o m   u s e r   i n p u t� ��� W    V��� l   Q���� k    Q�� ��� I   ������
�� .sysobeepnull��� ��� long��  ��  � ��� I   )����
�� .sysodlogaskr        TEXT� m    �� �   V A r e   y o u   s u r e   y o u   w a n t   t o   a b o r t   t h i s   s c r i p t ?� ��
�� 
btns J    !  m     �  D o n ' t   A b o r t �� m    		 �

 
 A b o r t��   ��
�� 
dflt m   " # �  D o n ' t   A b o r t ����
�� 
disp m   $ %��
�� stic   ��  �  Z   * D���� =   * 3 n   * / 1   + /��
�� 
bhit 1   * +��
�� 
rslt m   / 2 � 
 A b o r t l  6 @ R   6 @��
�� .ascrerr ****      � **** m   < ? �    U s e r   c a n c e l e d . ��!��
�� 
errn! m   : ;��������     aborts the script    �"" $   a b o r t s   t h e   s c r i p t��  ��   #��# l  E Q$%&$ O  E Q'(' r   I P)*) I   I N�������� 0 getuserinfo getUserInfo��  ��  * o      ���� 0 uniqname  ( o   E F���� 0 uniqnamelib uniqnameLib% 1 + gets uniqname from file or from user input   & �++ V   g e t s   u n i q n a m e   f r o m   f i l e   o r   f r o m   u s e r   i n p u t��  � @ : if -128 is returned, user clicked cancel in getuserInfo()   � �,, t   i f   - 1 2 8   i s   r e t u r n e d ,   u s e r   c l i c k e d   c a n c e l   i n   g e t u s e r I n f o ( )� >    -.- o    ���� 0 uniqname  . m    ������� /0/ l  W W��������  ��  ��  0 121 l  W W��34��  3 � � Get the computer's main Ethernet MAC address (stripped of colons), which is needed for getting the exact filename of the networkConnect plist:   4 �55   G e t   t h e   c o m p u t e r ' s   m a i n   E t h e r n e t   M A C   a d d r e s s   ( s t r i p p e d   o f   c o l o n s ) ,   w h i c h   i s   n e e d e d   f o r   g e t t i n g   t h e   e x a c t   f i l e n a m e   o f   t h e   n e t w o r k C o n n e c t   p l i s t :2 676 O  W g898 r   _ f:;: l  _ d<����< 1   _ d��
�� 
siea��  ��  ; o      ���� "0 ethernetmacaddr ethernetMACaddr9 l  W \=����= I  W \������
�� .sysosigtsirr   ��� null��  ��  ��  ��  7 >?> r   h u@A@ c   h qBCB l  h mD����D n   h mEFE 2   i m��
�� 
cworF o   h i���� "0 ethernetmacaddr ethernetMACaddr��  ��  C m   m p��
�� 
ctxtA o      ���� .0 ethernetmacaddrstring ethernetMACaddrString? GHG l  v v��������  ��  ��  H IJI l  v v��KL��  K E ? Get the current bsd-device name for the AirPort hardware port:   L �MM ~   G e t   t h e   c u r r e n t   b s d - d e v i c e   n a m e   f o r   t h e   A i r P o r t   h a r d w a r e   p o r t :J NON r   v �PQP n   v �RSR 4   � ���T
�� 
cworT m   � �������S l  v �U����U I  v ���V��
�� .sysoexecTEXT���     TEXTV b   v �WXW m   v yYY �ZZ Z n e t w o r k s e t u p   - l i s t n e t w o r k s e r v i c e o r d e r   |   g r e p  X n   y �[\[ 1   | ���
�� 
strq\ m   y |]] �^^ , H a r d w a r e   P o r t :   A i r P o r t��  ��  ��  Q o      ���� &0 airportdevicename airPortDeviceNameO _`_ l  � ���������  ��  ��  ` aba Q   � �cdec k   � �ff ghg r   � �iji n  � �klk 1   � ���
�� 
txdll 1   � ���
�� 
ascrj o      ���� 0 	olddelims 	oldDelimsh mnm r   � �opo m   � �qq �rr   p n     sts 1   � ���
�� 
txdlt 1   � ���
�� 
ascrn uvu l  � ���������  ��  ��  v wxw l  � ���yz��  y ; 5 Get the MAC address for the AirPort hardware device:   z �{{ j   G e t   t h e   M A C   a d d r e s s   f o r   t h e   A i r P o r t   h a r d w a r e   d e v i c e :x |}| r   � �~~ n   � ���� 4   � ����
�� 
citm� m   � ����� � l  � ������� I  � ������
�� .sysoexecTEXT���     TEXT� b   � ���� m   � ��� ��� 8 n e t w o r k s e t u p   - g e t m a c a d d r e s s  � o   � ����� &0 airportdevicename airPortDeviceName��  ��  ��   o      ����  0 airportmacaddr airPortMACaddr} ��� l  � ���������  ��  ��  � ��� r   � ���� o   � ����� 0 	olddelims 	oldDelims� n     ��� 1   � ��
� 
txdl� 1   � ��~
�~ 
ascr� ��}� l  � ��|�{�z�|  �{  �z  �}  d R      �y��
�y .ascrerr ****      � ****� o      �x�x 0 	errstring 	errString� �w��v
�w 
errn� o      �u�u 
0 errnum  �v  e k   � ��� ��� r   � ���� o   � ��t�t 0 	olddelims 	oldDelims� n     ��� 1   � ��s
�s 
txdl� 1   � ��r
�r 
ascr� ��q� R   � ��p��
�p .ascrerr ****      � ****� o   � ��o�o 0 	errstring 	errString� �n��m
�n 
errn� o   � ��l�l 
0 errnum  �m  �q  b ��k� l  � ��j�i�h�j  �i  �h  �k  � ��� l     �g�f�e�g  �f  �e  � ��� l     �d�c�b�d  �c  �b  � ��� l      �a���a  �GA***************************************************Change the EAP trust settings of the "Entrust.net Secure Server Certification Authority"cert to "Always Trust" (this handler uses a file containing the exported trust settings from a cert with the correct settings): ***************************************************   � ���� * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  C h a n g e   t h e   E A P   t r u s t   s e t t i n g s   o f   t h e   " E n t r u s t . n e t   S e c u r e   S e r v e r   C e r t i f i c a t i o n   A u t h o r i t y "  c e r t   t o   " A l w a y s   T r u s t "   ( t h i s   h a n d l e r   u s e s   a   f i l e   c o n t a i n i n g   t h e   e x p o r t e d   t r u s t   s e t t i n g s   f r o m   a   c e r t   w i t h   t h e   c o r r e c t   s e t t i n g s ) :    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *� ��� l     �`�_�^�`  �_  �^  � ��� i   ��� I      �]�\�[�] 00 changeentrustcerttrust changeEntrustCertTrust�\  �[  � k     '�� ��� r     	��� b     ��� o     �Z�Z <0 mwirelessappsupportdirectory mwirelessAppSupportDirectory� m    �� ��� 4 t r u s t - s e t t i n g s - i m p o r t - f i l e� o      �Y�Y 40 certtrustsettingfilepath certTrustSettingFilePath� ��� I  
 �X��W
�X .sysoexecTEXT���     TEXT� b   
 ��� m   
 �� ��� D s e c u r i t y   t r u s t - s e t t i n g s - i m p o r t   - d  � n    ��� 1    �V
�V 
strq� o    �U�U 40 certtrustsettingfilepath certTrustSettingFilePath�W  � ��� Z    %���T�� E    ��� 1    �S
�S 
rslt� m    �� ���  s u c c e s s f u l l y� L    �� m    �R�R  �T  � R    %�Q��
�Q .ascrerr ****      � ****� m   # $�� ��� � T h e   M W i r e l e s s   I n s t a l l e r   w a s   u n a b l e   t o   a l t e r   t h e   t r u s t   s e t t i n g s   f o r   t h e   n e c e s s a r y   c e r t i f i c a t e s .� �P��O
�P 
errn� m   ! "�N�N��O  � ��M� l  & &�L�K�J�L  �K  �J  �M  � ��� l     �I�H�G�I  �H  �G  � ��� l     �F�E�D�F  �E  �D  � ��� l      �C���C  � � �*****************************************************Appends an 802.1X user profile for MWireless to the computer's existing 802.1X profile set using the cl utility 'networksetup'*****************************************************   � ���� * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  A p p e n d s   a n   8 0 2 . 1 X   u s e r   p r o f i l e   f o r   M W i r e l e s s   t o   t h e   c o m p u t e r ' s   e x i s t i n g   8 0 2 . 1 X   p r o f i l e   s e t   u s i n g   t h e   c l   u t i l i t y   ' n e t w o r k s e t u p '  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *� ��� l     �B�A�@�B  �A  �@  � ��� i   ��� I      �?�>�=�?  0 configure8021x configure8021X�>  �=  � k     ��� ��� O    ��� r    ��� I    	�<�;�:�< &0 makeobjectfileops makeObjectFileOps�;  �:  � o      �9�9 0 fileops fileOps� o     �8�8 0 bdlib bdLib� ��� r    ��� b    ��� o    �7�7 <0 mwirelessappsupportdirectory mwirelessAppSupportDirectory� m    �� ��� * u s e r P r o f i l e T e m p . p l i s t� o      �6�6 80 userprofileworkingfilepath userProfileWorkingFilePath� ��� r    H��� J    F�� ��5� K    D�� �4���4 00 eapclientconfiguration EAPClientConfiguration� K    (�� �3���3 0 outeridentity OuterIdentity� m    �� ���  � �2���2 20 ttlsinnerauthentication TTLSInnerAuthentication� m       �  P A P� �1�1 *0 onetimeuserpassword OneTimeUserPassword m    �0
�0 boovtrue �/�/  0 accepteaptypes AcceptEAPTypes J    " �. m     �-�- �.   �,	�, 0 username UserName o   # $�+�+ 0 uniqname  	 �*
�)�* 80 userpasswordkeychainitemid UserPasswordKeychainItemID
 m   % & � H 6 D 4 0 3 C D 2 - D 8 E D - 4 0 6 3 - A 8 3 9 - F 8 2 2 F E 8 E 3 D 4 B�)  � �(�( 0 UniqueIdentifier   m   + . � H 6 D 4 0 3 C D 2 - D 8 E D - 4 0 6 3 - A 8 3 9 - F 8 2 2 F E 8 E 3 D 4 B �'�' "0 userdefinedname UserDefinedName m   1 4 � " M W i r e l e s s   P r o f i l e �&�& 0 Wireless Network   m   7 : �  M W i r e l e s s �%�$�% 0 Wireless Security   m   = @ �  W P A 2   E n t e r p r i s e�$  �5  � o      �#�# "0 newuserprofiles newUserProfiles�  l  I I�"�!� �"  �!  �     l  I I� !�    0 * export existing 802.1X profiles (if any):   ! �"" T   e x p o r t   e x i s t i n g   8 0 2 . 1 X   p r o f i l e s   ( i f   a n y ) : #$# I  I Z�%�
� .sysoexecTEXT���     TEXT% b   I V&'& b   I R()( m   I L** �++ T n e t w o r k s e t u p   - e x p o r t 8 0 2 1 x P r o f i l e s   A i r P o r t  ) n   L Q,-, 1   M Q�
� 
strq- o   L M�� 80 userprofileworkingfilepath userProfileWorkingFilePath' m   R U.. �//    n o�  $ 010 l  [ [����  �  �  1 232 O   [ |454 r   a {676 l  a y8��8 n   a y9:9 1   u y�
� 
valL: n   a u;<; 4   n u�=
� 
plii= m   q t>> �??  U s e r P r o f i l e s< n   a n@A@ 4   g n�B
� 
pliiB m   j mCC �DD 
 8 0 2 1 XA 4   a g�E
� 
plifE o   e f�� 80 userprofileworkingfilepath userProfileWorkingFilePath�  �  7 o      �� ,0 existinguserprofiles existingUserProfiles5 m   [ ^FF�                                                                                  sevs  alis    �  Main Volume                ��MNH+   ���System Events.app                                               �
��8Qg        ����  	                CoreServices    ��#      �8'7     ��� ��F ��E  9Main Volume:System:Library:CoreServices:System Events.app   $  S y s t e m   E v e n t s . a p p    M a i n   V o l u m e  -System/Library/CoreServices/System Events.app   / ��  3 GHG l  } }����  �  �  H IJI l  } }�KL�  K d ^ copy all user profiles *except* any using the MWireless network to the new user profile list:   L �MM �   c o p y   a l l   u s e r   p r o f i l e s   * e x c e p t *   a n y   u s i n g   t h e   M W i r e l e s s   n e t w o r k   t o   t h e   n e w   u s e r   p r o f i l e   l i s t :J NON X   } �P�QP Z   � �RS�
�	R >   � �TUT n   � �VWV o   � ��� 0 Wireless Network  W o   � ��� 0 i  U m   � �XX �YY  M W i r e l e s sS s   � �Z[Z o   � ��� 0 i  [ n      \]\  ;   � �] o   � ��� "0 newuserprofiles newUserProfiles�
  �	  � 0 i  Q o   � ��� ,0 existinguserprofiles existingUserProfilesO ^_^ l  � �����  �  �  _ `a` l  � �� bc�   b T N set the temp .plist file to use the old list of user profiles plus MWireless:   c �dd �   s e t   t h e   t e m p   . p l i s t   f i l e   t o   u s e   t h e   o l d   l i s t   o f   u s e r   p r o f i l e s   p l u s   M W i r e l e s s :a efe O   � �ghg r   � �iji o   � ����� "0 newuserprofiles newUserProfilesj n      klk 1   � ���
�� 
valLl n   � �mnm 4   � ���o
�� 
pliio m   � �pp �qq  U s e r P r o f i l e sn n   � �rsr 4   � ���t
�� 
pliit m   � �uu �vv 
 8 0 2 1 Xs 4   � ���w
�� 
plifw o   � ����� 80 userprofileworkingfilepath userProfileWorkingFilePathh m   � �xx�                                                                                  sevs  alis    �  Main Volume                ��MNH+   ���System Events.app                                               �
��8Qg        ����  	                CoreServices    ��#      �8'7     ��� ��F ��E  9Main Volume:System:Library:CoreServices:System Events.app   $  S y s t e m   E v e n t s . a p p    M a i n   V o l u m e  -System/Library/CoreServices/System Events.app   / ��  f yzy l  � ���������  ��  ��  z {|{ l  � ���}~��  } c ] import the old list of 802.1X profiles which now includes the fresh MWireless user profile:    ~ � �   i m p o r t   t h e   o l d   l i s t   o f   8 0 2 . 1 X   p r o f i l e s   w h i c h   n o w   i n c l u d e s   t h e   f r e s h   M W i r e l e s s   u s e r   p r o f i l e :  | ��� I  � ������
�� .sysoexecTEXT���     TEXT� b   � ���� m   � ��� ��� T n e t w o r k s e t u p   - i m p o r t 8 0 2 1 x P r o f i l e s   A i r P o r t  � n   � ���� 1   � ���
�� 
strq� o   � ����� 80 userprofileworkingfilepath userProfileWorkingFilePath��  � ��� l  � ���������  ��  ��  � ��� l   � �������  �]W**********THIS SECTION COMMENTED OUT ***************************************
	--Now must manually hack the eap bindings plist file because of a bug in 10.6: 		set eapbindingsPlistPath to POSIX path of ((path to preferences folder from user domain as string) & "ByHost:com.apple.eap.bindings." & ethernetMACaddrString & ".plist")		-- if eap bindings file exists, check for existence of MWireless key:	tell application "System Events"		if fileOps's existsFilePath(eapbindingsPlistPath) is true then			set eapBindingsList to item 1 of ((value of property list file eapbindingsPlistPath) as list)			set oldFilteredBindingsList to {}
			repeat with i in eapBindingsList				-- if no MWireless key, add it:								-- if there is an MWireless key, modify its UniqueIdentifier property:								try -- an error here is most likely caused by absence of |Wireless Network| property, so just skip it					if |Wireless Network| of i does not contain "UM Secure Wireless" and |Wireless Network| of i does not contain "MWireless" then						set oldFilteredBindingsList to oldFilteredBindingsList & i					end if				end try			end repeat			set newBindingsPListIdentContents to oldFilteredBindingsList & bindingsPListIdentContents			set newBindingsPListContents to my listToRec({{apMACaddr, newBindingsPListIdentContents}})			set value of property list file eapbindingsPlistPath to newBindingsPListContents		else -- no eap bindings file exists, so copy the boilerplate one and insert the correct MAC addresses into its name and its contents:			do shell script "sed " & quoted form of ("s/AirPortMACaddr/" & airPortMACaddr & "/") & " " & quoted form of ("/Library/Application Support/U-M Secure Wireless/com.apple.eap.bindings_template.plist") & " >" & eapbindingsPlistPath		end if	end tell		**********************************************************************************   � ���� * * * * * * * * * * T H I S   S E C T I O N   C O M M E N T E D   O U T   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 	 - - N o w   m u s t   m a n u a l l y   h a c k   t h e   e a p   b i n d i n g s   p l i s t   f i l e   b e c a u s e   o f   a   b u g   i n   1 0 . 6 :    	  	 s e t   e a p b i n d i n g s P l i s t P a t h   t o   P O S I X   p a t h   o f   ( ( p a t h   t o   p r e f e r e n c e s   f o l d e r   f r o m   u s e r   d o m a i n   a s   s t r i n g )   &   " B y H o s t : c o m . a p p l e . e a p . b i n d i n g s . "   &   e t h e r n e t M A C a d d r S t r i n g   &   " . p l i s t " )  	  	 - -   i f   e a p   b i n d i n g s   f i l e   e x i s t s ,   c h e c k   f o r   e x i s t e n c e   o f   M W i r e l e s s   k e y :  	 t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s "  	 	 i f   f i l e O p s ' s   e x i s t s F i l e P a t h ( e a p b i n d i n g s P l i s t P a t h )   i s   t r u e   t h e n  	 	 	 s e t   e a p B i n d i n g s L i s t   t o   i t e m   1   o f   ( ( v a l u e   o f   p r o p e r t y   l i s t   f i l e   e a p b i n d i n g s P l i s t P a t h )   a s   l i s t )  	 	 	 s e t   o l d F i l t e r e d B i n d i n g s L i s t   t o   { }  
 	 	 	 r e p e a t   w i t h   i   i n   e a p B i n d i n g s L i s t  	 	 	 	 - -   i f   n o   M W i r e l e s s   k e y ,   a d d   i t :  	 	 	 	  	 	 	 	 - -   i f   t h e r e   i s   a n   M W i r e l e s s   k e y ,   m o d i f y   i t s   U n i q u e I d e n t i f i e r   p r o p e r t y :  	 	 	 	  	 	 	 	 t r y   - -   a n   e r r o r   h e r e   i s   m o s t   l i k e l y   c a u s e d   b y   a b s e n c e   o f   | W i r e l e s s   N e t w o r k |   p r o p e r t y ,   s o   j u s t   s k i p   i t  	 	 	 	 	 i f   | W i r e l e s s   N e t w o r k |   o f   i   d o e s   n o t   c o n t a i n   " U M   S e c u r e   W i r e l e s s "   a n d   | W i r e l e s s   N e t w o r k |   o f   i   d o e s   n o t   c o n t a i n   " M W i r e l e s s "   t h e n  	 	 	 	 	 	 s e t   o l d F i l t e r e d B i n d i n g s L i s t   t o   o l d F i l t e r e d B i n d i n g s L i s t   &   i  	 	 	 	 	 e n d   i f  	 	 	 	 e n d   t r y  	 	 	 e n d   r e p e a t  	 	 	 s e t   n e w B i n d i n g s P L i s t I d e n t C o n t e n t s   t o   o l d F i l t e r e d B i n d i n g s L i s t   &   b i n d i n g s P L i s t I d e n t C o n t e n t s  	 	 	 s e t   n e w B i n d i n g s P L i s t C o n t e n t s   t o   m y   l i s t T o R e c ( { { a p M A C a d d r ,   n e w B i n d i n g s P L i s t I d e n t C o n t e n t s } } )  	 	 	 s e t   v a l u e   o f   p r o p e r t y   l i s t   f i l e   e a p b i n d i n g s P l i s t P a t h   t o   n e w B i n d i n g s P L i s t C o n t e n t s  	 	 e l s e   - -   n o   e a p   b i n d i n g s   f i l e   e x i s t s ,   s o   c o p y   t h e   b o i l e r p l a t e   o n e   a n d   i n s e r t   t h e   c o r r e c t   M A C   a d d r e s s e s   i n t o   i t s   n a m e   a n d   i t s   c o n t e n t s :  	 	 	 d o   s h e l l   s c r i p t   " s e d   "   &   q u o t e d   f o r m   o f   ( " s / A i r P o r t M A C a d d r / "   &   a i r P o r t M A C a d d r   &   " / " )   &   "   "   &   q u o t e d   f o r m   o f   ( " / L i b r a r y / A p p l i c a t i o n   S u p p o r t / U - M   S e c u r e   W i r e l e s s / c o m . a p p l e . e a p . b i n d i n g s _ t e m p l a t e . p l i s t " )   &   "   > "   &   e a p b i n d i n g s P l i s t P a t h  	 	 e n d   i f  	 e n d   t e l l  	  	 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *� ���� l  � ���������  ��  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l      ������  � � �************************************************************
Set AirPort's top preferred network to MWireless.  Note that this handler modifies the *current* network set (location).
*************************************************************   � ���� * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 S e t   A i r P o r t ' s   t o p   p r e f e r r e d   n e t w o r k   t o   M W i r e l e s s .     N o t e   t h a t   t h i s   h a n d l e r   m o d i f i e s   t h e   * c u r r e n t *   n e t w o r k   s e t   ( l o c a t i o n ) . 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *� ��� l     ��������  ��  ��  � ��� i    ��� I      �������� *0 setpreferrednetwork setPreferredNetwork��  ��  � k     �� ��� l     ������  � r l to ensure that MWireless appears as the first network in the list, it must be removed first, then re-added:   � ��� �   t o   e n s u r e   t h a t   M W i r e l e s s   a p p e a r s   a s   t h e   f i r s t   n e t w o r k   i n   t h e   l i s t ,   i t   m u s t   b e   r e m o v e d   f i r s t ,   t h e n   r e - a d d e d :� ��� I    �����
�� .sysoexecTEXT���     TEXT� b     	��� b     ��� b     ��� m     �� ��� Z n e t w o r k s e t u p   - r e m o v e p r e f e r r e d w i r e l e s s n e t w o r k  � o    ���� &0 airportdevicename airPortDeviceName� m    �� ���   � n    ��� 1    ��
�� 
strq� l   ������ m    �� ���  M W i r e l e s s��  ��  ��  � ��� l   ��������  ��  ��  � ���� I   �����
�� .sysoexecTEXT���     TEXT� b    ��� b    ��� b    ��� b    ��� m    �� ��� b n e t w o r k s e t u p   - a d d p r e f e r r e d w i r e l e s s n e t w o r k a t i n d e x  � o    ���� &0 airportdevicename airPortDeviceName� m    �� ���   � n    ��� 1    ��
�� 
strq� l   ������ m    �� ���  M W i r e l e s s��  ��  � m    �� ���    0   W P A 2 E��  ��  � ��� l     ��������  ��  ��  � ���� l     ��������  ��  ��  ��       ���   ��������  � 	�������������������� <0 mwirelessappsupportdirectory mwirelessAppSupportDirectory�� $0 uniqueidentifier uniqueIdentifier�� :0 sysconfigprefsplistfilepath sysconfigPrefsPlistFilePath
�� .aevtoappnull  �   � ****�� $0 validatecomputer validateComputer��  0 gathersettings gatherSettings�� 00 changeentrustcerttrust changeEntrustCertTrust��  0 configure8021x configure8021X�� *0 setpreferrednetwork setPreferredNetwork� �� G��������
�� .aevtoappnull  �   � ****��  ��  � ������ 0 	errstring 	errString�� 0 	errnumber 	errNumber� 9���������������� f��������� m�� w y������ ����������� ��� � � � ������������������� ����)-��5>��IQ
�� .miscactvnull��� ��� null
�� afdrasup
�� 
from
�� fldmfldl
�� 
rtyp
�� 
ctxt�� 
�� .earsffdralis        afdr
�� 
alis
�� .sysoloadscpt        file�� 0 bdlib bdLib�� 0 	errstring 	errString� ������
�� 
errn�� 0 	errnumber 	errNumber��  
�� 
mesS
�� 
as A
�� EAlTcriT
�� 
btns
�� 
cbtn�� 
�� .sysodisAaleR        TEXT�� ,0 makeobjectsysteminfo makeObjectSystemInfo�� 0 sysinfo sysInfo�� 0 uniqnamelib uniqnameLib�� $0 validatecomputer validateComputer��  0 gathersettings gatherSettings�� 00 changeentrustcerttrust changeEntrustCertTrust��  0 configure8021x configure8021X�� *0 setpreferrednetwork setPreferredNetwork��  ��  
�� EAlTwarN
�� 
dflt
�� 
psxf
�� .aevtodocnull  �    alis
�� EAlTinfA
�� 
TEXT��[*j  O ������ �%�&j 
E�W ,X  ��a �%a %�%a a a a kva ka  O� *j+ E` UO ������ a %�&j 
E` W .X  a �a �%a %�%a a a a  kva ka  O �*j+ !O*j+ "O*j+ #O*j+ $O 
*j+ %W &X & 'a (�a )a a *a a +kva ,ka  Oa - )a .a //j 0UO*j  Oa 1�a 2a a 3a a 4kva ,ka  OPW .X  a 5�a 6&a 7%�%a a a a 8kva ka  OP� ��c���������� $0 validatecomputer validateComputer��  ��  � ���� 0 interfacelist interfaceList� %m����t{�����������������������~�}���|�{�z��y��x��w�v��u�t�s�� 0 sysinfo sysInfo�� 0 getosversion getOSVersion
�� 
btns
�� 
dflt
�� 
disp
�� stic    �� 
�� .sysodlogaskr        TEXT
�� 
rslt
�� 
bhit
� .GURLGURLnull��� ��� TEXT
�~ 
errn�}��
�| 
netp
�{ 
intf
�z 
pnam
�y .sysobeepnull��� ��� long
�x 
mesS
�w 
as A
�v EAlTcriT
�u 
cbtn�t 
�s .sysodisAaleR        TEXT�� ��g B�j+ � 6����lv����� O��,a   a j Y hO)a a la Y hVOa  *a , *a -a ,E�UUO�a  *lj Oa a a a a  �a !kva "ka # $Y h� �r��q�p���o�r  0 gathersettings gatherSettings�q  �p  � �n�m�l�k�n "0 ethernetmacaddr ethernetMACaddr�m 0 	olddelims 	oldDelims�l 0 	errstring 	errString�k 
0 errnum  � &�j�i�h�g�f��e	�d�c�b�a�`�_�^�]�\�[�Z�Y�XY]�W�V�U�T�Sq��R�Q�P��j 0 uniqnamelib uniqnameLib�i 0 getuserinfo getUserInfo�h 0 uniqname  �g��
�f .sysobeepnull��� ��� long
�e 
btns
�d 
dflt
�c 
disp
�b stic   �a 
�` .sysodlogaskr        TEXT
�_ 
rslt
�^ 
bhit
�] 
errn
�\ .sysosigtsirr   ��� null
�[ 
siea
�Z 
cwor
�Y 
ctxt�X .0 ethernetmacaddrstring ethernetMACaddrString
�W 
strq
�V .sysoexecTEXT���     TEXT�U &0 airportdevicename airPortDeviceName
�T 
ascr
�S 
txdl
�R 
citm�Q  0 airportmacaddr airPortMACaddr�P 0 	errstring 	errString� �O�N�M
�O 
errn�N 
0 errnum  �M  �o �� 	*j+ E�UO Hh��*j O����lv����� O�a ,a   )a �la Y hO� 	*j+ E�U[OY��O*j  	*a ,E�UO�a -a &E` Oa a a ,%j a i/E` O ;_ a ,E�Oa  _ a ,FOa !_ %j a "m/E` #O�_ a ,FOPW X $ %�_ a ,FO)a �l�OP� �L��K�J���I�L 00 changeentrustcerttrust changeEntrustCertTrust�K  �J  � �H�H 40 certtrustsettingfilepath certTrustSettingFilePath� 	���G�F�E��D�C�
�G 
strq
�F .sysoexecTEXT���     TEXT
�E 
rslt
�D 
errn�C��I (b   �%E�O��,%j O�� jY )��l�OP� �B��A�@���?�B  0 configure8021x configure8021X�A  �@  � �>�=�<�;�:�> 0 fileops fileOps�= 80 userprofileworkingfilepath userProfileWorkingFilePath�< "0 newuserprofiles newUserProfiles�; ,0 existinguserprofiles existingUserProfiles�: 0 i  � *�9�8��7�6��5 �4�3�2�1�0�/�.�-�,�+�*�)*�(.�'F�&�%C>�$�#�"�!Xup��9 0 bdlib bdLib�8 &0 makeobjectfileops makeObjectFileOps�7 00 eapclientconfiguration EAPClientConfiguration�6 0 outeridentity OuterIdentity�5 20 ttlsinnerauthentication TTLSInnerAuthentication�4 *0 onetimeuserpassword OneTimeUserPassword�3  0 accepteaptypes AcceptEAPTypes�2 �1 0 username UserName�0 0 uniqname  �/ 80 userpasswordkeychainitemid UserPasswordKeychainItemID�. �- 0 UniqueIdentifier  �, "0 userdefinedname UserDefinedName�+ 0 Wireless Network  �* 0 Wireless Security  �) 

�( 
strq
�' .sysoexecTEXT���     TEXT
�& 
plif
�% 
plii
�$ 
valL
�# 
kocl
�" 
cobj
�! .corecnte****       ****�? �� 	*j+ E�UOb   �%E�O������e��kv�����a a a a a a a a a kvE�Oa �a ,%a %j Oa  *a �/a a  /a a !/a ",E�UO ,�[a #a $l %kh �a ,a & 	��6GY h[OY��Oa  �*a �/a a '/a a (/a ",FUOa )�a ,%j OP� � �������  *0 setpreferrednetwork setPreferredNetwork�  �  �  � 
����������� &0 airportdevicename airPortDeviceName
� 
strq
� .sysoexecTEXT���     TEXT� ��%�%��,%j O��%�%��,%�%j ascr  ��ޭ