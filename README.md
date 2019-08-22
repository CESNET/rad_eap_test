# rad_eap_test
rad_eap_test is a Nagios compatible shell script used for testing RADIUS
servers by EAP. It internally uses eapol_test to do the actual testing.

Usage is simple (for more info run rad_eap_test without any arguments):

```
rad_eap_test -H <radius.server.name> \
    -P 1812 -S <secret> -u <user@realm.tld> \
    -p <password> -m WPA-EAP -e PEAP
```

as output you might get:

 - `access-accept; <latency>`
    program exits with return code 0
 - `access-reject; <latency>`
    program exits with return code 1
 - `timeout; <timeout>`
    program exits with return code 2
 - `sort of config problem`
    program exits with return code 3

More speficic outputs are also possible based on options used.

# dependencies

rad_eap_test requires several programs to run:

- eapol_test
- dig
- bc
- sed
- awk

## compiling eapol_test

To compile eapol_test do the following:

```
apt-get install libnl-genl-3-dev libdbus-1-dev libssl-dev pkg-config gcc make
wget http://w1.fi/releases/wpa_supplicant-2.8.tar.gz
tar xvzf wpa_supplicant-2.8.tar.gz
cd wpa_supplicant-2.8/wpa_supplicant
cp defconfig .config
sed -i 's/^#CONFIG_EAPOL_TEST=y/CONFIG_EAPOL_TEST=y/' .config
echo -e "# IPv6 support for eapol test\nCONFIG_IPV6=y" >> .config
make eapol_test
cp eapol_test /usr/local/bin
```

# examples

Try to authenticate on the radius server `radius1.example.com`:

```
'rad_eap_test' -H 'radius1.example.com' -M '12:34:56:78:9a:bc' -P '1812' -S 'shared_secret' -e 'PEAP' -i 'example autehntication' -m 'WPA-EAP' -p 'testing_password' -t '50' -u 'user@example.com'
```

Additional options used set:
- username is set to `user@example.com`
- password is set to `testing_password`
- timeout is set to 50 seconds
- client's MAC address is set to `12:34:56:78:9a:bc`
- shared secret is set to `shared_secret`
- server port is set to `1812`
- EAP method is set to `PEAP`
- connection info is set to `example autehntication`
- method is set to `WPA-EAP`
- password is set to `testing_password`
- timeout is set to `50` seconds
- username is set to `user@example.com` 

# certificates

When using rad_eap_test to verify server certificates igainst CA certificate or to save server certificates, be aware that
rad_eap_test uses its own logic to extract server certificates. Using eapol_test to extract server certs directly seemed to be
too buggy for production use (there may be some duplicit certificates, server cert may be mixed with CA cert or server cert may not be saved at all).
If you encounter any problems with certificate extraction, please let us know.

# contributing

If you find that rad_eap_test is lacking some feature or has some bugs, simply create a pull request or an issue.

# older code

The original code (before major refactoring) is available in branch [old-code](https://github.com/CESNET/rad_eap_test/tree/old-code).

