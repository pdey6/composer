ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �VY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-�v˽�z�iSU���xU�^��RM��!�lZ�C�.w��2�p��?�`B���9&���l�����C���� sG������6 \[nk��x��O�mG3�5��-S����@g�� �������/Õ5�G�܄k�X�5�:
kt-h�P�C;ҋt)�j���xY�+�
���Y&a�hk�i4������l!_�JG�|n#�^�� ��@��&�t7iT\T��m�4�k�n�5�jk
�"�BFun0OH9��pM\��ϓ�ؚ�I`���
$	h�af4������h�	���z�5m�i�Mد�H�QSB%���̵&4[.Je��X�V��z�~3F���h�:�n[�Z$��3�i�0��Z�3<C�$�
y;ҐQ�ܛ�ޏ��ceR'o��l�0���c����Z�sEf:6�U��ч�w1g�U�������`�&*�0������H���#:EQW�^��UDY��e���զF�%��씥�h��=�au�٢.��vL��?�h�2�̅�!�!gp�;�q����xRa;��C#wNO��8����7�\�C�����sN��G>��iʶjvo�
;��� ��_��,���g�<��<�-�����"U͈Te�A9f�V ��<�J�����B��.!�7����RRzü���3|�5�:*��馌�}�Y~�����?�}ܜ�*�lt!����0F�-Y9A���cwB��bW�X���<��x��!lv!�� ���hG;YyѾ��0a&�B�mP���$��	pͺ`�̓	@6Tb� 5�F��6�M�}����j�x��3`�Z[v1��݂$Hn��2�xغ�@�!%Qgn��E��.Z����p:��ʉҐ�b�[c�eSo�"9xI��/���U����WY�Rt�ɡℙ��[9�[�����&4������	{	YS�^5HW[���d[ihm�]o���l�a��Fp �˼PE��c����%W84T?׼(6���(��~��PL/M�Ч.s�׬�D]O�۪݁��?�A�����B���o.���� ky��2�Q��'����چM�Q v�04�~�)�P�D�kZO�Q�(���?y��.,�N�QZ���d�E�W뀦�ۗ8K�Pi���B�p�2";J��k�;A6b�t[�<
�O�3U�qn����]I���#?Y�	H� T�t/p-n�+���%q��DY�k�C!uV�d��ƒ��`�Mf�K{��:������q�=���}�����،��q?I�f�g��+B`k����%��c��>������ު�����EQvŖ�D�w�D�]��*�á
��:]С�@�@*.�44�L�݀� My���S�A�׀T6��Z� ��9����(?��47��������KĄ���I>!8};�0�gD�^P��|���%��>�W5/G�<�\?:�B�����c�܉����av����뿹����q���l�;�1A�Y��3$����;�t�ԥ����<�1� -OV�*f�:Mam7m�UOAk�6��H�1�.�ʔ�o0�P��L���,e
������d���Օ����w�e�Q�C�H���L�hW*�3���K��Wx�怖�@�RҝV�<p��\�	�}
��:O�#^
,?�B���(��X�U2Y)�S����q��<x�@�X��l���Y�+�	m����7Lh���'�+1�x�<Kx�����۷��!�啬��R�e`��Uh�໯��D%,N��dBA�+t ��V��P���#��[�"�p�@(�`/�?�Il����U�{�8�3�6��������|`��}�0v�'��]. '��e���x�Y��<���z|S��a5�f��u
Y6�ig�7�����3�bԹ5���!}��4f���3Bt��9���x�Ä�[�I���A�������0}���-xR���!��c��\`h�W«p�@kp�q�m�~,[3\C�ٔ�	Sx����?��P��F�%�z$��Il��1N�qa`�!ė:p��j�S"��t��c�hΒ3���G�H��� �� E��������;x�9.�ay��>۽�5�<�z��(�	Bv�<���<��r"��?Y䛱�.� ����^�o�<Q��Q�縅��>T���#�-����=��e�8ƹ�=��8,�:x�����=[��X�	�a��
��:����7_�L/�7�����C��	���ޫ�����z��}ta
�����$��R���Lc��?�����g����?�=���>t[ָ���B�~�0���|[p��GtD���B������������@ �/f �Y����'H� !kF(Ev���)�����Krh���.q��iB���44��_�3x7�n*��07x��9���ir��f�zn��;t�̓w���t1��{iTh�fwO�܊��2�S?��6O`0�E�uA�:�9��~?�u���*����j��]u���
���5�f�����Ҙ���1���ę�b�����V��7c���{�%5p�W,㑊W�ޥax�����'�JلT*�v�GI�HD�K91�-���1O ���\��1Đ+��!,)�!�!Q2B.�c8���tT��ґ�J��rYܩ�SREJV�A��,*I����*�-C;C�p�-��e�rvП`��|:�ɥ���]i{=%%v�#�3�uT##���̑�*��[�(n��ٰؕ�������N)S�h�+J��mTl�:*��Y�*��ξ�,��[V���u�8�7�@W�w@�B
Xvt-���� �T�w.�r��[M��g\���o��C���wS������0<�#1\�����G�F��Gvɝ-�
�p�}�KH�9N�n V_�S;{���N��_C}�)|�?p���o b��L�Y��������x:�go�4��9�������c0m���R�I��s���h������M�?!�=�E��0�.�5n ���d\Ƴ���S���ly�y��^���S w�(X{� !��_yw�u+��p�0���K'�����_X��2�p���㘃� =���*t�I��ih�gO�_�~zfKi��1	�k�i��6�BL��Q�/ǣa`!�s�~�?Y$�T5�z��>z�wy��:����a4����P��_<޿�����_�X�_�������r�ô^^�:�Y@)���������\&�=�>�A0��Xc	���f��=���L�
��N�O�?23���w�K)�
���_��p�[~^eط�ʗT.n���#2������$c�C��,�U���ڹ�ݚ�^�	��C�*|���v���A�����^w��3����Gc��<`������h���Qf�������ihL����2��1�[�s�w�$xw���4��g(�6��xx��-�м�����4���ױ�L�����k�hG���X��^n���u�*�YB�Z�br-
ea���+lTP!�1Q�&TWW9rB-��rњRS����UDB����&cQ��Z����4��O�0$�t&�R����$ŊDB�l&��:N&E5];��X�3�Ea��k�*����V��3�sq+Q��6N��b1%':٢�94����n���:�vwΥJ��)��n�G�;h+M�گH{�D��%β�n�������,��Wϥ�lB�R7��j���-�:Lo�J�L�n����%�x�����F�9˝�L�8s�=��ʁ�º^���n8g���D=���+��[ɖ��+YF�X���3령ڭ6�F����Iܦ�a+�{���Q2^5�͜�p�v�����R�R���A���'	T��vs7���v���>��f7N:Rg���22��LR,�g��XTRź(�Z�ru�$�;��z���.on��cV��y�z��:yhl�ƒ���2v^'��1�グs���3��+z�/�'�5^Pr'�Ͷ �lZ���S84��f$!����ճ�,�g�U��͊f:�t�bqg�|"+vH�ԑ�N1���Vg?uh�|��b'c�uS�ڹ=����eA/��+����+�i�V���y���7�f'Y�J}h�rK�/�J�S3��t�en���b�1T�u\���[i}���Oj+�}M_UN��$3)�rh씊���_E]]�b�Wώ7������H���s&iD�\j�h��=N-��@8��t�4�ۚ����?����2�w7L_d�*���{�g z�m��ux��O���m��~��˾�������
 �e���O�N\(evѤ��}���fқb]���螦���*�����#m&�LG��r�X/3���`%!����^��e����ʫ�v�X��}E�*{��\z��m��\R�����+J��r;�TB�(�ь�Al���
���Q_�3eG:UKJz;q�\i�m������R�PO��l�U�@z`�%G�GT_�-�}����������?����U��/���1�s�����o.��wۙdp��275�<�z���1����>��}��f���~f�=���$�������[��4�~�)������?�������������
Tx���c��
�\T�UU幸,DN���l��*5Y��5��
������++K��l�_��������7���O����_l��/��߬��_=���!uIt)����hY:6�k�����O���:�-��?X��K����ᘶ���K��D}Q&���_��'K��`�g�}2�� �K�Gd'�Y�b�?�t�����!��񞭹HN��d������J_H����s���կ�����?������������'��+~v��K����m�0�y���Y�op�����7]��2�v^��2E9��$�D��S�wF���c=��30�G�C�'h����Y�@W�����c��ҮT�_9e1�-�\
����{
<����4��C($�����L�{aմz�DCK���"l����	�Ζ���m�d�B���*_��Ga��	BMQ`�U�5V��j��ʩ�Z��*ȱ�
�9A>rN@�����������q]���ߵ\�G{b��Q6�s2�:��ޕ�8�^gO<��p�����8�I2=�0�M��n�$�����CC\Ej�(JEI�9��Ar1�|t2@;A�0웁 ��A � �A|rHIU�*����.���
���������=n|?�h���mV���}��@?<'oɋ�V�h�bx��-�W���Y��lUbX)�8���YN6,{5��>q.f+�
[Y��x��>=���;�W.���̣Ez���by�Z��x
�#?���#�X�~����Nl�N4Y��`�yT]�P��+��4ύ'�Cp5ʋD����Ǧ;zx�c���qG���D_���d���ɪ]���J?���M���)��#v���*X���BX_ǹ����r��C��ko�(��}�qp�}WW�����e7F�c$Y�۟x���{�2�����5~a�$=��.MZ.y֍~/�9� dq�.��
]e.�s��g��¬��JW+�"W#���5�<;���c�`Β\��Y��$駶���Q�A.�ƋNr��ղ��`zY�Ɠ�v�x�'�?��	~$��N�b�ƕ$��4�~����NZ��������f�4�BUV�C��*�����?:6{�:���C���se�T��o�TH���GtR��P����:]`��MW�;��b.,Gdn�ga�\��5;�'���bf�����+�>ӋO�M�.�ړE����	��즓X��_Z���Ŵ���ǆ��Pn3b������fZ��6��2p�'w*v[P��ץ���Y��I������}�����jP^~�������q���n���������~%�w���+���_}�~��?���?�x���ߤS�V~T~Pf�o���K����W�X�kI��Bi��?�qT���CGM,��M�ng�v�me3(l�N������X�Y�2�&��S�֥?���~�����?��o������?|��/}��*�?+�RR�� x�4X�~�~���E���S�~�4��������?��ԏ�J��[���%��@�,34MZ�qj�D��P� Q�B���A��'ɛ����`�2 ��e�oG�UU��sRZ��:
ݭtt����Ҥ�`�y��/�
���\��~~�!���SN!�K_a�ܬ5g'�f��7��%c��@k<��:FEP���g�R���4�ϼ�g��gI��M��$��&���v&�uYr
	I��bh����t_UʦS�L^r"�_�'��L�4c�a��vxr�dl����3�Pr�fT+a-�yA��a[
��B2�H�e��ɜSC�l%�_��,�"�H��$@9Έr�<%��X[0IE�K)$��twyAGt)�v�mnς������ح�y�0�i��8���4��"s��N�H2T�tYrD�5ZCt ����Z�:��j#���%��h1T$�+�Ki����-~D
�J[z��";6�L��L���|D��&�ƲI}����ғU%��U����
b�$��R��hpj��.d�<�a�K�U<6ZȰ���#Ab#&Z墓�h5ԙ�Hs)�K6c���v�;T8�� �I�\��՞>�sz���>8�0��Q�B�ju��A7r����|Gf�Ja�J/�"��U��zyQ �D(hR$���T�(�����D�`�U�Hf��mb��*�@-�,F�&Pm�<��E{��w�Q�&!��:]$'\���i��$��	�Ҽ�t��2���p��&�K$��P2�Iwje�G�-�+�'�r����,����Y"��G;�	�u ������,��[Z���Y�tPչ�vD�ͬh
�JM�ކS�QY�Yt�<�(��mp����3����	)�5l�xN`5�A�E���چ��c>�{��F���ST��y:<�� ��s�� @h�|%Ö�B���2���:��*�Ԉ�rn��Ŗ5�*�+��aiҹLX���J}}�Rক<�My���� 7-�nZ�ܴ��ip��<�Mx����\�X�7�����^I~c��j+�=�t+��S�x�R��A��ߟ9���k����<>9>������k'�[�PO<�ӛ�_�&�;��|�tO�Go~���x��^���Rr����ƻ4?g�WQ�PR:�QNc�Sx��@;1ދ�1�7����^�x�`��&e|MiR x9/���� �Y��Ru�_ˎ˃�Fe(�|�&�b�(�<q#q4��	W��Ś�L�\_)�Jcƪʷa�S���k���l�� s�ar=�Pjy�B6�զv~j�4�o��xgI�B�~�Wd)������W��k����m�a�)�z����X�t�f�5�k�e��Y&�\���sQ�Y��a���%=�0��%�&��l�ȕ2n�ى��B�*v�鎪��S�X�<7�N�p���8e�i�����z��U;ʀX6#��=�����8R�y���h�����5%����`P�e��b�.�2�>8 %3D�44�YC�գ�Ǩ�М�l�����*��,53�C���a�QlG}Qa2~��h�����s�*�E�`�b5�Jo*�uS�e�J��j�g�Z��tu�$;��b�'U��S�Xd��=���e����q�A���,�v���ϧ�����':�������?O�~� �������?Xj��>H�̓�7�9��+!���|fp���TuG-��ғ��"BQ΄���=kŝgH�Xq�ȹ�(��,�.�OPxbX��:� O+��=��h+T<�%T,�71
��Z�X�w�:r����xKb�ё3#���N�KzMT�;���k����s�#��h$9]�:���)Ԧ����7�X-r�>:�nP}���d5� K�8�m-�.n��bw����o���?�(J�b�a�K���@��bܙ�Å�3l�<@{ݢ�!M�V�:��ZDؖ'�>u:��i=�c 72�%��c ��b�,ceg��ZH#�)�.D!h-1P�Pd��AS$An��1�����Q=(��2���A�:�hT�&Zѭ�e�dn��1���xɷ����~��K�%yoM����n�Y�I��	l��u 0�8V^R��?I������u ��T�NW���H��B:�Y�詜G#����.�E�1��Z~T��dLU;+���\E	���&���N�`�|�G,DD'����l�MV��x����F�D��M��%e6��t��@�JOke\OQ#�)w5����U��UW�̠Xw��S	K�h�����X9�G�!X�0Ocx�}�R���s��U��s��9��/�>�>Z�{�G�>cѪ���~�����_�����5V�Nk�
��ѐI c$�6!��5��q?���pf�8�ymDN�	B�j��
g0f���*1�Z�q���A���~8�J�cF��ka0ke���kXP�7,�m�%�1S����<�ق�y?��e�!�Tf�^GRaII��:<^]���b5c-� L�=p>�W{�
��e�;�	�X����X���5�nz�F�6D��v=��-ԥ�tv�P#�[NĽzKe�¨Җ¶^�5�%� B\y8��1jň����R5S�XP@G�`H�D�7/�+\�DO����t�R�p-��F������I���럄��@�}�ID�_XE4%+��E��0up�x�+��$G���P��ԛ�W��C�����J��FGv�V��k���|�=��O>��v��<ʲiw��S?�,�A��X�{��;突�y���s��k<�����j��/_��<\��s�e��E�;���7c=�q�s����O����ى?�����L{�^� �GcQ{���Ob��	;����4GVZa��R���۪��"�g>���A8 >��yQ�)����M\�O��;���}��۠��f�̖{<���� ���z��Q6�4����۠;���7��A���A��/k5w�=���nc���q���m�]����?�E��t[�A�����O{������F7�?���۠���]�o�!��������?�l��=����_��}|a��]�g�n�/��g����}��[�}��Q��p��(�z�>���%�����A;�������)�����������������]��1���������u1��g�����ѝ�����,����۠�ɫ+��������;����?�=�����ΰ�<g���7�|���]���X�S��\��
u�6ㆴ��}F������@AǾ}c�_�#'�����>>���A�:�'�QN��a
���KP�r�V�� :o�ZD�6���&�w�^_�I-3�G^ؑ�Q�K7�bd7�����Lw`[{�'��i��ǣ�:�q�;*8����������(�nY/(�邍���3���|�A:Q�NQ�D����
9��ÎXt�&pm�5��8i���K�4'g n6\���
҂�/뎲�����N�����e���w�c��k�±?�����h������]������]��0s6Y:L�(�������e�x�PH�m��1P��Q�ε!׳���ep�l�&�8|^��٦���(o������Z��kRQ�=��<���\!�:��v�)��Il@���ѫͥ��*t�? �b2��5�U? ���*s���!ݑ��"b�1h���X���0vR�9�s�lf� ��ޙ5)�eQ��_��F���C?� *�2����™�����{��ԕ�����z0��T*{���:��(/M7� ��v�͢����ݹ>�{V�S�f���l0������{zS�?p����O��������?����K��g�Ɂ�k,�_������FhD�aU[�����~����{{`��a��a��7��"�N��������$:�8&c����$�r*r*�蘹���4��\�#����#h�8��W�
��W����3�غ�*M�-b�!=ns.����Ul��wm�[����w�S�Eܞ],�\�W&T/{��f@,�Ò���RH�bp�)����'�vb.��U�>�^��*���6_��U�����?�>�H��j����MU� �4q������?��������f�b�q������������?�|cES�����,��&��o����o��F{���/���L�1߸��}�8�?�j�/�7B���d���
�?Jp���+��ߍ���ď�o�S�W}�bk�4��4۔ŏλ��b�V���?���n�6��zTh��i�������\k�Z���&f�w�>������ W�v'��={YNuZV��er8���:>v�x��]�Rl1�¸^�������U��f�G�NW���]��:�W(������}S��wW.��69V�P�v��ɲ){6i[۶B�ԣ�D��FmS��!=��BS��_��k�1�J>�v��\�A �T�ЭN̬�q�fC�+Lx}�ˊ{�@�c�v��V������ތ�GC����=ǒ�B��ҵ��}�R���_�@\�A��W���C�� ������?���?����h����������?�������N�=_���,���`��U�G��m[�mNyy�a�J�=�SN�[Q�K�z�L�����CcAF��wV^sb?������U���M͟�a�&oy��]O����/��c��w`e�.��ߺ���ͭ�$��6y�{�)�7�B�>����<p�}�d.ʀR�X_
���f^��c���$/;����?���T4S��1��?���A���Wt4����8�X�A����������?/�?��4��?�O�㛢~��k���?��9���������O��	����7���Ԁ���#��y���	�?"�����/���o|�VQД������ ����������CP�A0 b������ga���?�D������?������?�lF���]�a����@�C#`���/�>����g9�I�y��j�o������Ɵ�ߘ�Yg6�Z�9�=��E���?���?7�sP���uRt�Y|����Qg��=Ic�'���9���L�WlG�/C"2F�����+�SS[ӣC���؜�vՒ.Z���:��r�l��e���_x���n�?{|U�༿����^.d��T:�)�lev�o􏇛w0��`u*�,%mڦp���޸���Yh��V���@�TfQ�Ju��E8�Y�.��O�k�j�B ;�B����p�a���EZ:v�{����N9k�1f��E�=��W����g�&@\���ku�2��� ����?��y����p����r!��<�������҂(r\������H�S"˦�(�,˱�D�C��z����78�?s7�O�σ�o�/����{w��/C?��ww���V����Go���kylx�r��a��q���k�.f����|�XO��raˣ�,�^�PXeXus{<��6�z�
q����rLȋe�/'�Н�r�M�E$h�Z�_&��If_І5��X�����=�)�8f�����t4���� �;px���C���@������������G�a�8����t�����`��@������Ā�������D���#�������������������������B�!�����������Y�~��|���#�C�����g񽳷L����|�������8?|3���o&�����x�Hκ5y�d�,������,��v�����kf����<��Q��ڛ��Yk�V_�K5�/�l#]��za�aݕ?|����4��9ao�x3*zt6m��}�Ǫ�̔�N��J��e���Ч�XwO!-����G|�td���0'�5�5�4r��J��t��u8=�?�eMg�q����C�<��c�ʲN�ۡ���-��۪pݒ���[��s|2Z7g>-M]����'��	���p����ux��e��9*]�����+�\����'�1e�6�P%�ߥP:V����ݒ>��j��2�_O����۹���0^��}梕3�mv4��O]%ծ�ږ��X�;��=��Nn�e �SA7�u��U.��r-%��$�N_妄k[��l��q��M��s�dI!F��z���)�Ͽ���n��� ���?��@���]������\�_"i:�*ɲ4�i6ʙ,⥘�D�ᓄgi�Is>�$��h>gE�f�$Ob*�3	�?~��?��+�?r������ق8��Ó8��"��0��?�#�%^?�Xc�T����vgmUI�I��[uƺ�N8/����T�>�}��Z��|(��,����v����A{{���)j������?�����������	p���W�?0��o������q����3��@�� ���/t4������(�����#���Bb���/Ā���#��i�������=���+�4 7GS�����M��r1�]6;���,��4`�����{��.�t���S���-q�8�NG��� ����k��Y͜��l�|�媥�e�L�j�V]�?O�۸c�u�u��t[�6��Q�ߎ׬������֦��҃�b��]���%������%	�����<��ԙ�'b������XS���cY2]�J�EκQJ���D��FY���{�ӝc���3�H���2aG�2Vμ�o���?��q��_�����?,�򿐁����G��U�C��o�o������1���E6����?�~`�$������=]�[��7��닾#�K݅�@!	�����q�&U	�l���f"�YA��Q�P�0�+kL/��sZ���VFӓ>`]k�O������<ߢK���/E�z[Y�i�����z�YAMe��ц��{ɫ#���_=YU4y���n�9vM����滍��F���@����t���j;>����y�/S��Ү#�^�����V,�5iC�[��k�����ߥQ�E��_�@\�A�b��������/d`���/�>����g9�������[����N�/����[�4_Z�|�J��P����ǿ���B~��~�{뤐O_���W=~w��RYZ�rf�cW��M&,����epȧ[�= ��<���p��m
R������u�F֯���j�դL��u�:EX(������www����>�����^.d��T:��.��Z�C�#�j�g���A<�fd��z3�L%�)��A�U39u�8`�׉�{��ӎL�eSs;}�Cw'R��6���f���3�0ҋv93�����˼\�uN�Y�2g!"[ӽ�:�Y���Cnݪ�K.�-J-�Jte�T�6��������/d �� �1���w����C�:p��J*O�!9��DLQ���(��Ȍ�D&�IA��/�|D�t��#�<$�~��U��5¯��*֫�-�Ex�egA����=�q)�g��9�vZ�s���ݩ5�)�t�[c����h��kӉ��n��t�
W�����8�Ƴ�$_)��z���vijb8럒�<2��Y���������X����ߍ����D`����3�����5�/O�O��w#4�����-M����S��&��o����o����?��ެ�cy6�82Ϥ8�2!%�OҜ�R*�RV�9I�96!91a8�g(!�.��4�S>���������� ��~e���7�s�+I��1��C?v:�m���V�o�y<���K���^ר:U����[��b�i����+Z�2;�X�{tN72����e�î���W�b�u5��ϳ��YQբ�F{�����}���0��o����� li���L������!���?�|�
�?�?j����? �����Ɗ���G�Y8�� ��!��ў�����_#4S�A�7�������?��Y�ۏ8��W��,��	`��a��Ѯ���7*��� �W���������Ѵ�C /���o����?����p�+*�������^�����ρ�o��&_��3��MД�����j@�A���?�<� ����6#�����/�������XDAS������5������������A����}�X�?���D���#��������������_P�!��`c0b�������������C.8p����9��n����o����o�����/p�c# ��Vٵ:��D������P/����7.��E�Ȥigy�ё�K��e\,r'�	�1�$l������Yl&�+�b���������O=� ��	�������ο-�����<ה��4+:YG�ހeͥ�j���kiS�ݲs~E�9C�?�=�&*�I?�TD�P}kUrR��T%'�W��I"��Z.�z��k�/����ch|Rw����r�����fC��?<�V�Yv�<i'�;�9��������'�jq�f'@i�LS�$��f!ᕣ�fL����t��e�c|6EǺa��2�V�Ww���~�{�>��A�Gwh���������ޡ����C/��t����t����;���������������t0�������@�u��@�G� ��c�^�?���=�`�;����������A���?���1��������?:Co�������� �;��0�������o�?y���Ty���h6(4��R��`�Y]��aeo2^=j��ž�<��oH����re�$A��J�K����3_z3L��.�!��&�X\��7֦�Y�RŎ�����}�f5�\<E��پ5%��ڶ6�њ�b�j�K5/sa��6`SV���#�%�<%^����Z�Y�Sv�e�i�;�![>L�������B/�����?���1��������?�C_�?���?$}&�P��Q:�)�C��c2F����� D��������c����� ��;���dQ��;��[<�{�I�-OY|t9��Xq��a���a����a`'�V'gM0mX=�0�j�q̰���Jf�;��ٞ]n�dh�S�|t0��O�1��6�J���Z�xv�A��{�o~��C����������@���?�����%���
���x��$F������a}��@�O+h��y^�C��*�q�$���pc5�|���>C	&�HfH aD#�7"`�� �x����`�C+���O���
���(KpnC���Ɯ�zS�R�S�t�&؏���K��!`����n�;f�?2X�f+\_&XZ�Kh.F�N��T�'8���`$yP������3?ᖜ7)��/������{ч�?J�����ߖ���v�����������O48�mo�i­���:�5�fu�<�)����b��$���/7���_#�5����w�R�ވ�Kc����l��~��KrN�[��_��z���������疵��M���)�O��vqI�n�}��S9�y[@���+���ƽ���� �u�eT�Uy�sIn�pܤYG���e���p��_ua#4��,n�c�.��va�ϳ_:!N=�J|�Ob	[�sM��~p��3��J֦J:��5D��?a_{�RI�t�b6M(T�p��S����lA��!C5WeR܆�A�,v�ލg�k��LR�Wd�(�K<H�����[��_8��	����^��������?��/ ������wwh��_ր��ޠ-����~w�C`���u�3����W�?V�v�n����#!��X���������~��O�H엙�ї�������#dY����'�:�2L��=7"k�S����$��:���e��2�+�@�\�l9'���މh��S�>/v���,�9�<���x9�1���2��:�G}��f,��f�_d�����dV֤ˏ�S��/��l3�(,V��Pog��f�T����f/Ä/����		XU����g[Dx�K��8G0�n2��l�ZB6>h�Qy�ryZ-ؔ��*�H�~�ԓ@��.�)d�ƌ�H"��s��:_��|�-�A��/��[��[A���_ ����_�����&���&ܧ�T��w�>��|���������o�ߐ_�s}p��y}�"*˼�14��vY� N�e���{uލ��-���E���e��hn�yev�@�m����y��4��tl�����$�1�(��9��5?�� S
�T)�;�~����FxRӻ�I�
>n���G�-m3�P�Ϭ��Ҧ�%�f������ξD�Ȍ�q4�/G�@w�;��4��L������ ;*��_�͵��0��'WC��'�Q��3~NW��Qu��=/��t�*҈�S��cҊdS�����7��"����V�2���/����Y,(��%�Ꮖ^�?����S��_���{���&p����[�S�n��|'�Mk6I=��pK���	:�� �g���E}��`�g���E���JJ�z���T����P�d.텑�4�vl�V�9��j���2{ƈ�f'�f��P�*6l��VͫXVM^�{F���>U<����"�Z��}�̘0>�iEɤ��MiL�Ի��0antӾFqx�̵r�<%��0y�)g|R-!���O�=�B"��|`�52�#�ʝ&&q(,
	!�\Qr������-�?��3 �������_`�Ww��A���im�?P������A����U��[�7�a�w��co�Xrw5�@�"�Oր�׭ܐ��Weel���ԁ������[._� �06�\l}<lx̟���-S߸�]�[�K�h�9C�ɊG�����Z],�1��[^~|*�����Qcx�0�*:�����G�B��џ��:�]%�i,Χ���i�%�la5r�䎵.B�����U�̈3��G�h��9
��,!��|���If� �\8y������߭�+��_?��� ��&@�c+ �O �	�?}���^�?0��:���C�����?�������{�S�,�Σd�:
U��.g�� 6t뒠V����փ�X��#�=tw
KdV��z+s�"�/�Q��t�����ϝ���F���F�Tўǐ��*�[�����������k�����@��:�u��S4Qw�W����QBT��E��?Ηx�$��?qS�;�3)���Vw�Ǝg5�֧ ��l���; ߢ�����������J��S��������������P����A��;��������t���%��k���n_��g	��������@��o������B0��m���[� �=���]�?���4��6����p� �����?~����ZB�;D[��s��+���_+ �?P��?P���@�����N�~ �����z��؃�?P�k]�?0�����������?��`��6��	���������?��8��6�=��=�ZD/�?���c�����������٫�OV�v�n����#!��X����O�������Fb?g�q#Εн�s�^�}�k`�e�r�n����0-���T��9O���,���ƚ�	���j �s%���,�[{'��O��ؕ�/�X�d\�`�Ө�ŋ�7�� <oYz��I}�Ɖ�XV�/�f����dV֤ˏ�S��/��l3�(,V��Pog��f�T����f�kVu~"����Ҁ�1�����`*[�����gT��\�V6e��
#���;�$�t���h
Y�1#&����������G��o��y��
�[AW�/��U]"`����[�����G�����V�9�G11L�1C�NP��4s��tHR��Q�t� �ȫ5$��#�zx�՟������z��$��m������~>ɢ���K��~���IH���t=�S�6�%R_��#`(q��#D�SԅB�����̽�����fy�Ib�b*jm>N7���Es�A<�S鄠=E�Ɨ��P�2�`e�[���^�n�'͕�s8�r���s�}�uwO���g���%������?���/ eޞ����W����z��4u�� ��������� ����1���'����N��@u����;��������?��m��������
@�'����������翠��
:� �s ����_/���� �o��`�;C/����'����'���@�S����?@�s+�T�����������n��j	=������6���|�������˭�o���%��L����ً�����?J~��o�˷vҞ���	��Y�~�F��6;��/"��//(t���ꁠ'����N�^1��
sJ��p2�$}A�DFPW�ÈTY3�h����mi���$�o0����1tqf��mb��Rj�*���<[��Ͳs�.���ܺ�[M���K���X}9��Cl�\�_�x����ߟq��\���Ň���d�!vS;|}��F� .E�C�ն�\cJZ"+t6�ku�Ħ������*�	��h�B�f[sL,7�*0$����A������^�?����S�B�:��[����q�A���m�����8�� F��I1T�c��|�d|*����B��6��SLa!�x �W����t}���;�a�gSL}QYG�vN��!�9��*k�y<�*�������Ep���fZf��<]$~�#I\��|�s(�R2�-�~:9�/���2@g0��I��_c��X�X�t멫��x�ދ�~�o��z���_�����7>�(M~w��a48�k��/�Ow��Uk��'�֟�ݧ8=T���p(��iHw�'o��te������*�?�����l1�dW��lf{���vg҈`Z��d��ʮr90���\~�ˏ�z��vU�e�l�V�$��"-�$H���DHbE�h���@ �$��|�!��V

Uv�������>��t��|ﹷn�:�s�9�Z�DmrC�u��:�S�������ݝn�T-�+����/����'T$�b>���Wvbۉݸ�-�
{�&/����R> h��Շ��
b���H��8wf�^Ls睶{��Z�����p����Ӈ=]3�al)��[HH�f9�v�K�����;���q,ǌ��Q�j����|�����G�,A�� �xO,pLE��jOFwr���>�5��7���'����{�ֆ���z8����(������AW�Wۡ*<s��0��R�"J�P-�wC�W;G0�"�R�rUB�ߍ�#5�9�N��{�N u�^�-������ĝ�������o���ȏ�h"v[��g���=6���2��WhwFӐE�rND�R��t�O(;z���R�i��1G�t'\��9A����ݚc�?���O"������D����	xc��' ޸ ^�����>������\Z�ċ/����������jFO#IEok��,�"X�H�)8���F5��*�'U�1�b��(�]�"�������͇_�������~����^��8~�<8�)T�>.�׳��zچ.��B�BB���� />l���
���i����B�*,��t�+��>w���ֹC����6���B�
=�u����랪�p��g�+a�UAT��v�n��Ž�2`�6X�Mx��������|��o���������xm:�*t)��+��P_�|�����1uG�-9a<f{���b'��
Kn��=��������_~j��{o}*����o���߸��?��f��LS�}Oߕ����Ol��z.�+���h��<��Q(��ci/��aɶ��3�����Icl(iCI)z:���6�ƓH"��U4�A�vM�I=� 	X�ڡ�_��/�_���w���o������������C��?��?��'o����Co߀~p�)���7���W�m�yp!���硷��������\|X\���u� ^uXOH!A��}M�c��nS=W��ωDc?��2�֜I_��8�� �Q˜�e�0��B��R���EY�*�� p5?��1�eiΈ\H��(�ckH�Wꭉ�G����9��|�)W����֬YGm�Q��s�ő�q�����pz47~�CL�8���}�%M��!��\6O�e���՜Ggy30�ya\Rf���&fL�ot���!)��������Z *e��,'P���[I焍�g�E�� 1�M�H���	pd}u}=)ty��C�f�e�Vf����@�-�ɼ�k�t`���ڻ�ހ/`�b/v�������A�Y�b�!^jRM�h�<�HS3�
V|^$�L)Y�E���.�Pʀ�m��;$�N�B�m��4��n.�ʓ�,MH����9�ړ�*�I�.�*+w�c���#�%#AA��=���ib�Ü�k7(�L��a�<\f"��mK�Nb :h��q}.b���)U���9� �D�T��^{De�-�.��_�Ѵ����II�&�Q��&��ǽd�#0Y��0r��p��e�����IQ��f�Qq�ۢB�M&����5�[�x͉��L�r��;)��H|���&G*�Q�C�{�-���L�c$�@�s���,9�ǇY�ly�nX�V)�MW�\_�-�8xB��Umܝ��D5�~���v�T��z//�Ħ�4Nʴx���yL�r�)����d�5��f	�C��Y)w�8_��&,�l�k��gdrL��
�L5Zf�F���Y�^b;	Es�+����m�ј���8�o���ԫ`9��j2!8��1f9�|�Tf�S�5�I�g)�8������xb�˻b�)��/�e67:�{�)Y��![�YiX��ZrP7*V(w���Q�� f�y������}k�}}]+�5,?��b��&kt�Dg~d�]������"=~E��H����O�z�;�a�Il�/9kq�Mk������<6p4�m=����v�K�m��3��!���$�������ܠ@^NQ̐d�AZ�wJi������$y�VE�S��bj�[�O0�p8����yl`=�͵�I���.`���@��|�o��;�Xc�OP�+Tܾ����~"O�63`]vs�\�ѬFZ�96���i�k�t��e�A�K$���@�kU/�����&晩�����ڸ2p�Ik��'�����|<)�	��E�����N�`)�K�υ+�k�t1�~�����u�<^��W��χ�YkpemA�n��&>�M�W�п=s�&��3�_��4�_�}�
�GW*n���#�{%��Ŏ.Ҭ]+���X��{�,��1���n��x?�tMJ�M�A& gg�]K�f�ۭ�ܦ���H��Ġ^��MWy�VA:�!���6�{�8�SR��4� ���X�1r��x�{a��9Q��X{W7�=̍�����bˆE���95�S�/'3���{>4ޙh�j��e�@s��|���͑�����j0��;;R^���,��M�]�Q�4��hY��d��}�һ)�p�vE4���Ǭb	��O�}^�r���b�*�};.U�1���=5U��*6^�����<!)��4&|ٚ�jɱܜp%`t��1"=�Z�ӒP���y����J�Ffni|��{�Tz)��T�|���~�q���'a��4~Vof� k�r�kL�F:f=u��%]N�����R�_���_�;h�</��g����9L��3@.��ܛ򮤉��UȼPd�<`Sd5UnXm�(��wM�"��b�w�b�T�v<G-���:U�g�3�y�����X�6\��ڍ:_��?݅~t����b��[�߾���o܄��&�������)fs������'�K��P��g�z��$k��@�By����&��`������j��ٝl�0	��$0`�ɮDUv�x;��-�3����yj*dDM�sn���kj}T��av�r��c�:���`l��ʍ��ąG�P��O`ʨl�G8#����OyN<�7�C>	?�t�oR���xq6���n�a&��^���lQX��m�W�V�pB����%B���Ͳ_l�.�(2�gP�V�xE�&�t�m>�i6q�����sl��8�Om�c�z������'�[��n��g�~�S��[/6�z������2�^�[�G��A�k^�g���={����go��\�gn��h���G�����R;��}��_W�A��Ǿ8�t�*t<�=w� E���Ԏ`�u�9���z��������ֺyz�#Z}������B�D�+��9 ص#���8���v$�xg�׏f#�p^ϒQ⮬�,m��|Z+R� WC=ܱ��n���CP��=��o��,������@��"�8��֏Bxv����{�д����� m����x��8�WD�O,6��l`��6��l`�I���g � 