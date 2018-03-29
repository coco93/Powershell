New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "*.azurewebappname.p.azurewebsites.net"
#Running that command will add the self signed certificate to the local certificate store. When you run the command, you'll also get a certificate thumbprint that will look something like
#CE0976529B02DE058C9CB2C0E64AD79DAFB18CF4
$pwd = ConvertTo-SecureString -String "Pa$$w0rd" -Force -AsPlainText
Export-PfxCertificate -cert cert:\localMachine\my\CE0976529B02DE058C9CB2C0E64AD79DAFB18CF4 -FilePath e:\temp\cert.pfx -Password $pwd
