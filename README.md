# toolchain-fujprog
Apio package that contains the [fujprog](https://github.com/kost/fujprog) FPGA JTAG programmer for [ULX2/3S boards](https://github.com/ulx3s/ulx3s.github.io)

## How to create a new release

This information is for **developers**

* Clone the toolchain-fujprog
* Open the **build.sh** file
* Change the **VERSION** variable to the new version for the Apio package (For example VERSION=2020.10.6)

```bash
# -- fujprog apio package version
VERSION=2020.10.6
```

* Set the **fujprog version** to include in the apio package

 You should define two numbers. For example, for packing fujprog version v4.6:

```bash
# -- fujprog version to download
# -- Current v4.6
SRC_MAYOR=4
SRC_MINOR=6
SRC_VER=v$SRC_MAYOR.$SRC_MINOR
```

* **Save** the file
* **Execute** the building script for all the **architectures** you want to create

It will download the executables from the [fujprog](https://github.com/kost/fujprog) and package them for apio

The **apio target architectures** are:

 * linux_x86_64: For linux 64-bits
 * windows_amd64: for windows 64-bits
 * darwin: For Mac

Example: Building the package for Linux

```bash
bash build linux_x86_64
```

* The **apio packages** are stored in the local **releases folder**  
* Create the **new release of toolchain-fujprog** in Github  
The tag and name of the release should start with the **letter v** and have three numbers separated by a colon. Ex: v2020.10.6  
* **Upload the apio packages** from the releases local folder  
* Apio should **upgrade** to the new version with the **install command**:
```
apio install fujprog
```
* You can check that the new version is installed with:
```
apio install -l
```

## Credits

* The [fujprog](https://github.com/kost/fujprog) project has been developed by: Marko Zec, EMARD, gojimmpypi and Kost

* The building scripts are based on the [Tools-systems](https://github.com/FPGAwars/tools-system) by  
  * [Jesús Arroyo Torrens](https://github.com/Jesus89)
  * [Juan González-Gómez (Obijuan)](https://github.com/Obijuan)
