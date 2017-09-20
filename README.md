# java-jdk9

Existe uma cópia deste projeto em : https://github.com/docker-brasil/java-jdk9.git 

Mantenho aqui o projeto até resolver issue relacionada a publicação no Hub de Docker

A Docker image for use as a JShell playground

## Pull the image

    docker pull parana/java-jdk9

## Using the Image

    docker run -i -t --rm parana/java-jdk9

## Open a JShell session

No conteiner Docker execute:

```bash
jshell
```

Na console do JShell execute:

```java
import java.util.stream.*
IntStream.range(-9, 10).mapToObj(x -> Math.pow(Math.E, x)).forEach(System.out::println)
Stream<Double> fStream = IntStream.range(-5, 6).mapToObj(x -> 1.0 / (1 + Math.pow(Math.E, x))) 
fStream.forEach(System.out::println)
/save script-01.repl 
/exit
```

De volta ao terminal BASH do conteiner Docker execute:

```bash
cat script-01.repl && echo "" && echo ""
```
