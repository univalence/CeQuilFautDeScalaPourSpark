# @Ce qu'il faut de Scala pour Spark

Le didacticiel couvre les plus importantes fonctionnalités et idiomes de [Scala](http://scala-lang.org/) dont vous aurez besoin pour utiliser l'APIs Scala de [Apache Spark](http://spark.apache.org/). Puisque Spark est écrit en Scala, Spark suscite l'intérêt pour Scala, en particulier pour les _data engineers_. Les _data scientists_ utilisent Scala parfois. Mais la plupart utilise Python ou R.

Allez récupérer la [Lightbend Fast Data Platform](http://lightbend.com/fast-data-platform), notre nouvelle distribution de _Fast Data_ (stream processing), incluant Spark, Flink, Kafka, Akka Streams, Kafka Streams, HDFS et nos outils de gestion et monitoring en production, tournant sous Mesosphere DC/OS.

> **Conseils :**
> 1. Si vous suivez ce didacticiel lors d'une conférence, il est **nécessaire** de la configurer avant, car vous ne disposerez pas de temps suffisant pendant la session pour résoudre les problèmes.
> 2. Si tout échoue, il y a un PDF du didacticiel dans le répertoire `notebooks`.

## Prérequis

Nous supposons que vous avez déjà une expérience programmation, quelque soit le langage. Une certaine connaissance avec le monde Java est supposée. Mais si vous ne connaissez pas Java, vous devriez être capable de chercher des explication pour tout ce que vous ne connaissez pas.

Ce n'est pas véritablement une introduction à Spark. Une première utilisation de Spark est bienvenue. Mais nous présenterons brièvement la plupart des concepts que nous rencontrerons.

Tout au long du didacticiel, vous trouverez des liens vers plus d'informations sur les sujets importants.

## Télécharger le didacticiel

Commencer par cloner ou télécharger le projet Github du didacticiel https://github.com/univalence/CeQuilFautDeScalaPourSpark.

## À propos de Jupyter et Spark

Ce didacticiel utilise une image [Docker](https://docker.com), qui combine l'environnement de notebook populaire [Jupyter](http://jupyter.org/) avec tous les outils dont vous aurez besoin pour lancer Spark avec Scala, appelée [Tout Spark Notebook](https://hub.docker.com/r/univalence/tout-spark-notebook). Il contient [Apache Toree](https://toree.apache.org/) qui fournit un accès à Spark et Scala. la [page Web](https://hub.docker.com/r/univalence/tout-spark-notebook) de cette image Docker contient des infomrations utiles comme l'utilisation de Python et de Scala, les sujets sur l'authentification utilisateur, le lancement de vos jobs Spark Spark sur des clusters plutôt que le mode local, etc.

Il y a d'autres alternatives de notebooks que vous pouvez tenter selon votre besoin :


**Open source :**

* [Jupyter](https://ipython.org/) + [BeakerX](http://beakerx.com/) - un ensemble d'extensions efficaces pour Jupyter
* [Zeppelin](http://zeppelin-project.org/) - un outil populaire pour les environnements big data
* [Spark Notebook](http://spark-notebook.io) - un outil efficace, mais pas aussi bien maintenu

**Commercial :**

* [Databricks](https://databricks.com/) - un service possédant de nombreuses fonctionnalités, commercial et cloud-based
* [IBM Data Science Experience](http://datascience.ibm.com/) - l'environnment complet d'IBM pour la data science

## Exécuter ce didacticiel

Si vous avez besoin d'installer Docker, suivez les instructions d'installation sur [docker.com](https://www.docker.com/get-started).

Maintenant, nous allons lancer l'image Docker. Il est important de suivre les étapes suivantes avec attention. Nous allons monter le répertoire de répertoire de travail dans le conteneur lancé, afin qu'il soit accessible à l'intérieur du conteneur. Nous en aurons besoin pour notre notebook, nos données, etc.

* Ouvrez un terminal
* Allez dans le répertoire où vous avez déployé le projet du didacticiel ou cloné le repo
* Pour télécharger et lancer l'image Docker, exécuter la command suivante : `run.sh` (MacOS et Linux) ou `run.bat` (Windows)

Le script `run.sh` de MacOS et Linux exécute la commande :

```bash
docker run -it --rm \
  -p 8888:8888 -p 4040:4040 \
  --cpus=2.0 --memory=2000M \
  -v "$PWD":/home/jovyan/work \
  "$@" \
  univalence/tout-spark-notebook
```

Le script `run.bat` de Windows est similaire, mais utilise les conventions de Windows.

Les paramètres `--cpus=... --memory=...` ont été ajoutées parce que le "noyau" du notebook à tendance à crasher avec les valeurs par défaut. Modifiez selon vos envies. Aussi, il sera nécessaire de n'avoir qu'un seul notebook ouvert à la fois.

Le paramètre `-v $PWD:/home/jovyan/work` demande à Docker de monter le répertoire actuel à l'intérieur du conteneur en tant que `/home/jovyan/work`. _C'est nécessaire pour fournir un accès au données du didacticiel et aux notebooks_. Lorsque vous ouvrez l'UI du notebook (voir plus loin), vous verrez apparaître ce répertoire.

> **Note :** sous Windows, vous pouvez avoir l'erreur suivante : _C:\Program Files\Docker\Docker\Resources\bin\docker.exe: Error response from daemon: D: drive is not shared. Please share it in Docker for Windows Settings."_ Dans ce cas, faites ce qui suit. Dans la barre de tâche, près de l'horloge, cliquez-droit sur Docker, puis cliquez sur Settings. Vous verrez _Shared Drives_. Cochez votre disque et cliquer sur _Apply_. Allez voir [ce thread sur le forum Docker](https://forums.docker.com/t/cannot-share-drive-in-windows-10/28798/5) pour plus de conseils.

Le paramètre `-p 8888:8888 -p 4040:4040` demande à Docker de créer un tunnel sur les ports 8888 et 4040 du conteneur dans votre environnement local, ainsi vous pouvez obtenir l'UI de Jupyter au port 8888 et l'UI du driver Spark au port 4040.

> **Note :** ici, nous utilisons juste un seul notebook, mais si nous utilisons plusieurs notebooks en parallèle, le _second_ notebook Spark devra utiliser le port 4041, le troisième 4042, etc. Gardez ça en tête si vous voulez adapter ce projet pour votre propre besoin.

Vous devezvoir une sortie similaire à ce qui suit :

```bash
Unable to find image 'univalence/tout-spark-notebook:latest' locally
latest: Pulling from univalence/tout-spark-notebook
e0a742c2abfd: Pull complete
...
ed25ef62a9dd: Pull complete
Digest: sha256:...
Status: Downloaded newer image for univalence/tout-spark-notebook:latest
Execute the command: jupyter notebook
...
[I 19:08:15.017 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 19:08:15.019 NotebookApp]

    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://localhost:8888/?token=...
```

Maintenant, copier l'URL affichée et coller la dans la fenêtre de votre navigateur.

> **Attention :** lorsque vous quittez le conteneur Docker à la fin du didacticiel, tous vos changements seront perdus. À moins qu'ils soient dans le répertoire de travail que nous avons monté ! Pour sauvegarder des notebooks que vous avez créés dans d'autres emplacements, exportez les en utilisant le menu _File > Download as > Notebook_ dans la barre d'outils.

## Lancer le didacticiel

Maintenant nous pouvons charger le didacticiel. Lorsque vous ouvrez Jupyter, vous verrez `work` apparaître. Cliquez dessus pour l'ouvrir. Ouvrez `notebooks`, puis cliquez sur le notebook du didacticiel `CeQuilFautDeScalaPourSpark.ipynb`. Ce qui ouvrira un nouvel onglet dans votre navigateur. (Le PDF est un imprimé du notebook et peut servir en cas de soucis pour lancer le notebook.)

Vous noterez qu'il y a une boîte autour de la première "cellule". Cette cellule contient une ligne de code source `println("Hello World!")`. Au-dessus de cette cellule, il y a une barre d'outil avec un bouton qui contient une flêche orientée vers la droite et le mot _run_. Cliquez sur ce bouton pour lancer le code de cette cellule. Sinon, vous pouvez utiliser le menu _Cell > Run Cells_.


Après plusieurs secondes, une fois que l'initialisation est terminée, `Hello World !` est affiché en sortie juste en dessous du texte d'entrée.

Faites la même chose avec la cellule suivante. Il devrait être affiché `[merrywivesofwindsor, twelfthnight, midsummersnightsdream, loveslabourslost, asyoulikeit, comedyoferrors, muchadoaboutnothing, tamingoftheshrew]` qui est le contenu du dossier `/home/jovyan/work/data/shakespeare` : des textes de plusieurs pièces de Shakespeare. Nous allons utiliser ces fichiers comme données.

> **Attention:** Si à la place vous voyez `[]` ou `null` affiché, le montage du répertoire de travail courant ne fonctionnait pas correctement lorsque le conteneur a démarré. Dans une fenêtre de terminal, tapez `ctrl + c` pour sortir du conteneur Docker, veillez à ce que vous soyez à la racine du répertoire du projet (`data` et `notebooks` devraient être des sous-répertoires), relancez l'image docker et veillez à entrer exactement la commande comme indiqué.
Si ces étapes ont fonctionné, vous avez terminé de configuré le tutoriel !

## Et après ?
Vous êtes maintenant prêt à faire le tutoriel.

Vous ne voulez pas lancer le notebook Spark pour apprendre ? Un PDF de ce notebook est aussi disponible dans le répertoire `notebooks`.

Veuillez s'il vous plaît poster vos commentaires, bugs, ou même pull requests dans la [page du projet GitHub](https://github.com/univalence/CeQuilFautDeScalaPourSpark). Merci.

L'équipe du workshop.

## Note

Ce repo est une une traduction du repo https://github.com/deanwampler/JustEnoughScalaForSpark créé par Dean Wampler.
