# Isomorphism test
Ce script permet de tester une page avec plusieurs user agent et de vérifier le rendu de la page en fonction de ces derniers.

## Pré-requis 
* `curl`
* `pup`: https://github.com/ericchiang/pup

## Using Docker
* Build image : 
```shell
$ cd isomorphism-test
$ docker build -t isomorphism-test .         
```

* Run container
```shell
$ docker run isomorphism-test        
```