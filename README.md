# java-jdk9

Existe uma cópia deste projeto em : https://github.com/docker-brasil/java-jdk9.git 

Mantenho aqui o projeto até resolver issue relacionada a publicação no Hub de Docker

A Docker image for use as a JShell playground

## Pull the image

    docker pull parana/java-jdk9

## Using the Image

    docker run -i -t --rm parana/java-jdk9

## Open a JShell session

    import java.util.stream.*
    IntStream.range(0, 10).map(x->x*x).forEach(System.out::println)
    /save script-01.repl 
    /exit
