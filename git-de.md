# Inhalt

- [1. Grundlagen](#1-grundlagen)
- [2. Installation und Einrichting](#2-installation-und-einrichtung)
- [3. Lokale Versionsverwaltung](#3-lokale-versionsverwaltung)
	- [3.1. Erste Schritte](#31-erste-schritte)
	- [3.2. History und Logging](#32-history-und-logging)
	- [3.3. Wiederherstellung beschädigter Dateien und Rückgängigmachen von Änderungen](#33-wiederherstellung-beschädigter-dateien-und-rückgängigmachen-von-änderungen)
	- [3.4. Demo 1](#34-demo-1)
- [4. Dezentrale Versionsverwaltung und Git Hoster](#4-dezentrale-versionsverwaltung-und-git-hoster)
	- [4.1. Transferprotokolle](#41-transferprotokolle)
	- [4.2. Erstellen von SSH-Keys](#42-erstellen-von-ssh-keys)
	- [4.3. Erstellen eines Repositories auf den Hochschul-GitLab](#43-erstellen-eines-repositories-auf-den-hochschul-gitlab)
	- [4.4. Verwenden von Remotes](#44-verwenden-von-remotes)
		- [4.4.1. Entferntes Repository herunterladen und Remotes bearbeiten](#441-entferntes-repository-herunterladen-und-remotes-bearbeiten)
		- [4.4.2. Pushen von lokalen Änderungen auf den Server](#442-pushen-von-lokalen-änderungen-auf-den-server)
	- [4.5. Demo 2](#45-demo-2)
- [5. Versionsverwaltung im Team mit Branches](#5-versionsverwaltung-im-team-mit-branches)
	- [5.1. Erstellen von Branches](#51-erstellen-von-branches)
	- [5.2. Arbeiten mit eigenem Branch (z.B. für ein Feature)](#52-arbeiten-mit-eigenem-branch-zb-für-ein-feature)
	- [5.3. Mergen von Branches](#53-mergen-von-branches)
	- [5.4. Demo 3](#54-demo-3)
	- [5.5. Short-track für Bereitstellung eines Master Releases](#55-short-track-für-bereitstellung-eines-master-releases)
- [6. Erweiterte Funktionen](#6-erweiterte-funktionen)
	- [6.1. Versioning/Releases](#63-versioningreleases)
	- [6.2. Tagging](#61-tagging)
		- [6.2.1. Lightweight Tags](#611-lightweight-tags)
		- [6.2.2. Annotated Tags](#612-annotated-tags)
	- [6.3. Signieren von Commits](#62-signieren-von-commits)
	- [6.4. Submodule](#64-submodule)
	- [6.5. Ändern der Commit-History](#65-ändern-der-commit-history)
	- [6.6. Cherry picking](#66-cherry-picking)
	- [6.7. Rebasing](#67-rebasing)


# 1. Grundlagen

Git ist ein dezentrales Versionsverwaltungssystem. Es erfasst verschieden Versionen der verwalteten Dateien in einem Repository und ermöglicht jederzeit zu alten bzew anderen Versionen zurückzukehren. Die Änderungen lassen sich außerdem zu anderen Repositorien übertragen bzw. von dort abrufen. Dies ermöglicht es git gleichzeitig als Werkzeug für Datensicherung und Kollaboration mehrerer Teammitglieder einzusetzen.

Während git selbst primär ein Kommandozeilen-Tool ist, existieren diverse graphische Werkzeuge. Einige davon sind reine git-Oberflächen. Viele Programme, wie etwa die meisten Entwicklungsumgebungen, verfügen außerdem über eine integrierte Benutzeroberfläche. Wir behandeln hier lediglich die Kernkonzepte und die Kommandozeilenbefehle.

Es existieren viele weitere meist englische Tutorials im Internet. Einige sind hier aufgeführt.
- [Officielles Buch](https://git-scm.com/book/en/v2)
- [Arch Wiki](https://wiki.archlinux.org/index.php/Git)
- [KBromans Tutorial](https://kbroman.org/github_tutorial/)

Repository - Ein Repository ist ein Archiv für ein (Software-)Projekt und beinhaltet alle Änderungen und Versionen der Dateien

Branch - Ein Branch beschreibt zusammenhängende Änderungen in einem Projekt. Es gibt in jedem Repository mindestens einen Branch und es kann beliebig viele Branches in einem Projekt geben.

Commit - Ein Commit ist ein einzelner Änderungseintrag in einem Branch. Es beschreibt mindestens eine Änderung an mindestens einer Datei und enthält eine Beschreibung der Änderung (Patch), sowie Angaben über den Autor. Jeder Commit, mit Ausnahme des initialen Commits eines Repositories, enthält außerdem die Information auf welchem vorangegangenen Commit er aufbaut. Daher kann jedem Commit ein Zustand des Working Trees zugeordnet werden. Commits werden durch einen Hash über diese Informationen eindeutig identifiziert.

Working Directory/Working Tree - In einem Working Tree stellt git eine Arbeitsumgebung bereit. Er enthält alle von git verwalteten Dateien und eventuelle lokale Änderungen, die committed werden können.

Untracked files - Untracked files sind "neue" Dateien im Working Tree, die noch nicht von git verwaltet werden.

Modified files - Modified files sind Dateien im Working Tree, die zwar schon von git verwaltet werden, aber verändert wurden.

Staging Area - Die Staging Area enthält Änderungen (Patches) aus dem Working Tree und dient dazu einen Commit vorzubereiten.


# 2. Installation und Einrichtung

Für die Installation siehe:
- [Linux/Unix](https://git-scm.com/download/linux)
- [Mac OS X](https://git-scm.com/download/mac)
- [Windows](https://git-scm.com/download/windows)
- [andere](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

Weitere
- [openSUSE](https://software.opensuse.org/package/git)
- [Ubuntu](https://linuxize.com/post/how-to-install-git-on-ubuntu-20-04/)

Nach der Installation lässt sich die Version auslesen:
```sh
$ git --version
```

Git enthält eine umfangreiche Hilfefunktion:
```sh
$ git help
$ git help <Kommando>  bzw.  git <Kommando> --help
$ man git-<Kommando>
```

Zur Konfiguration des Anwenders:
```sh
$ git config --global user.name <myUserName>
$ git config --global user.email <user@example.com>
```

Anzeigen aller Konfigurationen:
```sh
$ git config --list
```

Zum Ausnehmen von Dateien aus der Versionskontrolle könnten diese in eine Textdatei namens .gitignore eingetragen werden. Dabei steht jede Zeile für eine relative Pfadangabe. Wildcards werden unterstützt. Die Datei .gitignore selbst sollte der Versionskontrolle unterliegen. Buildartefakte sollten ausgenommen werden.

Die Metadaten der Versionskontrolle werden in dem Ordner .git gespeichert. Der .git Ordner darf daher nicht gelöscht werden.


# 3. Lokale Versionsverwaltung

## 3.1. Erste Schritte

Versionskontrolle für aktuelles Verzeichnis initialisieren:
```sh
$ git init
```

Den aktuellen Status abfragen:
```sh
$ git status
```

Alle Änderungen abfragen:
```sh
$ git diff
```

Änderungen in Datei abfragen:
```sh
$ git diff <path>
```

Die Datei <file_name> zum Commit vorbereiten (zu Staging-Area hinzufügen):
```sh
$ git add <file_name>
```

Die Datei <file_name> von der Staging-Area entfernen:
```sh
$ git reset <file_name>
```

Alle Dateien zum commit vorbereiten (zu Staging-Area hinzufügen):
```sh
$ git add -A
```

Zum Commit vorgemerkte Änderungen anzeigen:
```sh
$ git diff --staged
```

Die sich aktuell in der Staging-Area befindenden Dateien committen:
```sh
$ git commit -m “this is the commit message”
$ git status
```


## 3.2. History und Logging

Anzeigen der Commithistorie des aktuellen Branches
```sh
$ git log
```

Lediglich Commits anzeigen die bestimmte Dateien betreffen
```sh
$ git log <path>
```

Anzeigen weiterer Informationen inklusive der vorgenommen Änderungen
```sh
$ git show <commit ID>
```

Anstelle der Commit-ID kann auch der Bezeichner `HEAD` für den ausgecheckten Commit verwendet werden. `HEAD~1` bezeichnet den Vorgänger von `HEAD`, `HEAD~2` den Vorgänger von `HEAD~1` usw.


## 3.3. Wiederherstellung beschädigter Dateien und Rückgängigmachen von Änderungen

Zurücksetzen von Dateien im Working Directory auf den Stand des Indexes
```sh
$ git checkout <path>
```

Zurücksetzen von Dateien im Working Directory auf den Stand des letzten Commits
```sh
$ git checkout HEAD <path>
```

Änderungen, die bereits committed wurden können nicht wieder aus diesem Commit entfernen, da dies eine Änderung der gesamten Historie bei jedem Entwickler erfordern würde. Stattdessen erzeugen Sie einen neuen Commit der die Änderungen rückgängig macht manuell oder mit dem Befehl
```sh
$ git revert [--no-commit] <commit> [<additional commits>]
```


## 3.4. Demo 1

Erstes Repository
```sh
$ mkdir demo1
$ cd demo1
$ pwd
/path/to/demo1
$ git init
Initialized empty Git repository in /path/to/demo1/.git/
$ git status
On branch master
No commits yet
nothing to commit (create/copy files and use "git add" to track)
$ touch file1 file2
$ ls
file1 file2
$ git add file1
$ git status
(...)
$ git commit -m “first commit”
$ git status
(...)
$ echo “change” >> file1
$ git status
$ git add file1
$ git add file2
$ git status
(...)
$ git commit -m “second commit”
$ git status
(...)
```

Auslesen der Commithistorie
```sh
$ git log
$ git log file2
$ git show HEAD~1

```

Korrigieren von Fehlern
```sh
$ echo "bad change" >> file2
$ git diff
(...)
$ git checkout file2
$ git diff
(...)
$ echo "another change" > file3
$ git add file3
$ git commit -m "another change"
$ git revert HEAD~1
$ ls
(...)
```

Klonen von erstem Repository
```sh
$ cd ..
$ mkdir demo1b
$ cd demo1b
$ git clone ../demo1b .
(...)
$ ls
$ git status
(...)
```


# 4. Dezentrale Versionsverwaltung und Git Hoster

Git basiert auf einem dezentralen Ansatz, bei dem jeder Client das gesamte Repository lokal vorhält. Dies ermöglicht nicht nur das einfache Erzeugen von lokalen Repositories sondern auch das Verknüpfen solcher mit einem oder mehreren entfernten Repositories.

Das Hosting solcher Remoterepositories wird oft in Verknüpfung mit einer Weboberfläche und weiteren proprietären Features angeboten. Einige bekannte Anbieter sind Microsoft GitHub, GitLab, Canonical Launchpad, Codeberg, Atlassian Bitbucket, SourceForge, Amazon AWS CodeCommit und Microsoft Azure DevOps. Im Folgenden werden die Hochschulinterne GitLab-Instanz und das öffentliche GitHub verwendet.


## 4.1. Transferprotokolle

Git unterstützt den Datentransfer mittels HTTPS und SSH. Dabei wird für einen anonymen Lesezugriff auf öffentlich verfügbare Repositories eher HTTPS und für nicht öffentliche Repositories und für Schreibzugriff eher SSH mit Public-Key-Authentifizierung verwendet. 

Das Format für HTTPS URLs ist `https://server/<path>`, das für SSH URLs `<user>@<server>:<path>`. Bei den meisten git-Hostern ist der Aufbau `https://server/<name_of_repo_owner>/<repo_name>` bzw. `git@<server>:<name_of_repo_owner>/<repo_name>`.


## 4.2. Erstellen von SSH-Keys

Für die Verwendung von SSH mit Git müssen Sie zunächst mit dem `ssh-keygen`-Befehl ein Schlüssel erzeuget werden. Sollten Sie bereits über ein Schlüsselpaar verfügen können Sie dieses verwenden.
```sh
$ ssh-keygen -t ed25519 -C "<my_name@stud.fb2.fra-uas.de>"
```
Bestätigen Sie den Standarddateinamen mit der Returntaste und geben Sie ein Passwort ein.
Es sollten zwei neue Dateien mit dem eingegebenen Filenamen mit den Namen `id_ed25519` und `id_ed25519.pub` im `.ssh` Unterordner des Benutzerverzeichnisses erzeugt worden sein. Prüfen Sie dies mit `ls`.

Sollte ein Dienst Ed25519 Schlüssel noch nicht unterstützen, sollten Sie ersatzweise einen RSA-Schlüssel verwenden. Die Erzeugung erfolgt analog.
```sh
$ ssh-keygen -t rsa -b 4096 -C "<my_name@stud.fb2.fra-uas.de>"
```
Nach der Erzeugung müssen Sie den öffentlichen Schlüssel bei den Diensten registrieren. Dazu müssen Sie in den Inhalt der `.pub`-Datei einstellen oder die Datei selbst hochladen. Detalierte Information finden Sie bei den Anbietern selbst, zum Beispiel hier:
[GitLab](https://docs.gitlab.com/ee/gitlab-basics/create-your-ssh-keys.html) ([erzeugen](https://docs.gitlab.com/ee/ssh/README.html#generating-a-new-ssh-key-pair), [registrieren](https://docs.gitlab.com/ee/ssh/README.html#adding-an-ssh-key-to-your-gitlab-account)) oder 
[GitHub](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/connecting-to-github-with-ssh) ([erzeugen](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent), 
[registrieren](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account))

Nachdem Sie Ihren Schlüssel registriert haben testen Sie die SSH-Verbindung mit dem Befehl `ssh git@github.com` bzw. `ssh git@gitlab.com`. Dabei werden Sie aufgefordert, den Hostkey des Dienstes zu verifizieren. Diese sind in der Regel auf den jeweiligen Websites dokumentiert. Sie sollten eine Ausgabe erhalten, dass die Authentifizierung erfolgreich war.


## 4.3. Erstellen eines Repositories auf den Hochschul-GitLab

Für die Übungen verwenden wir das Hochschul-interne GitLab, welches ein Git bereitstellt, aber darüber hinaus über weitere Funktionalitäten verfügt, die wir später noch benötigen.
Das Fra-UAS-GitLab ist [hier](http://gitlab.informatik.fb2.hs-intern.de) erreichbar.
Dazu müssen Sie entweder im Hochschulnetz sein oder sich mittels VPN in das Hochschulnetz einwählen. Sehen Sie hierzu 
[die VPN-Anleitung der Hochschule](https://www.frankfurt-university.de/de/hochschule/einrichtungen-und-services/leitung-und-zentrale-verwaltung/cit/vpn/)

Sie sind als Student des Fachbereichs 2 automatisch für den Zugriff auf GitLab vorbereitet. Loggen Sie sich daher bitte mit Ihrer Hochschulkennung ein. Leider können Sie selbst keine Projekte und Repositories erstellen. Bitten Sie daher Ihren Professor, Ihnen entsprechende Repositories einzurichten.
Falls Sie nicht warten möchten können Sie sich auch die Repositories bei der zentralen GitLab-Instanz oder bei GitHub einrichten, Sie werden aber für spätere Übungen auf jeden Fall ein Repository im GitLab benötigen

Erstellen eines Repositories auf GitHub

Gehen Sie auf <https://github.com> und klicken Sie: „Sign up for GitHub“.
Geben Sie einen Namen, eine E-Mail-Adresse und ein Passwort ein.
Danach gehen Sie in das E-Mail-Postfach dieser E-Mail-Adresse und bestätigen die Registrierung durch klicken auf „verify email-address“.

Rufen Sie <https://github.com/login> auf und geben Sie Ihren User und Ihr Passwort ein.
Klicken Sie auf „Create Repository“!
Geben Sie in das Feld „Repository name“ den Repository-Namen „demo2“ ein und klicken auf „Create repository“.
Ihr Repository ist nun erreichbar über https://github.com/<my_user_name>/demo2


## 4.4. Verwenden von Remotes

### 4.4.1. Entferntes Repository herunterladen und Remotes bearbeiten

Entferntes Repository herunterladen und Working Tree auschecken:
```sh
$ git clone https://github.com/<name_of_repo_owner>/<repo_name>
```
oder
```sh
$ git clone git@github.com:<name_of_repo_owner>/<repo_name>
```

Ein Repository von einem anderen Verzeichnis kopieren und Working Tree auschecken:
```sh
$ git clone <another directory>
```

Fügt ein entferntes Repository unter dem Namen „origin“ zu einem bestehendem lokalem Repository hinzu:
```sh
$ git remote add origin https://github.com/<name_of_repo_owner>/<repo_name>
$ git remote add origin git@github.com:<name_of_repo_owner>/<repo_name>
```

Zeigt alle entfernten Repositorien an:
```sh
$ git remote -v
```

Zeigt alle Branches an:
```sh
$ git branch -a
```


### 4.4.2. Pushen von lokalen Änderungen auf den Server

Bekannte Kommandos:
```sh
$ git status
$ git diff
$ git add
$ git commit
```

Übertragen neuer Commits vom Repository "origin" auf das lokale. Bevor Sie dies tun sollten Sie lokale Änderung committen:
```sh
$ git pull origin master
```

(Anmerkung: hierbei kann es zu Konflikten kommen, die durch paralleles Ändern an ein und derselben Datei aber durch verschiedene Entwickler entstanden sind. Diese müssen manuell aufgelöst werden (git diff, vim etc.).

Übertragen neuer Commits aus dem aktuellen auf das Repository names "origin". Sollten hierbei Konflikte gemeldet werden, pullen Sie zunächst, um diese lokal beheben zu können.
```sh
$ git push origin master
```


## 4.5. Demo 2

This Demo 2 clones a remote repo to a new local repo. Adds a local file “test.txt” to the local repo an pushes it to the central repo.

```sh
$ git clone git@github.com/<name_of_repo_owner>/<repo_name>
$ cd <repo_name>
$ git remote -v
(...)
$ git branch -a
$ echo “new”>>test.txt
$ git add -A
$ git status
(...)
$ git commit -m “this is the commit message”
$ git pull origin master
$ git diff
(...)
$ git push origin master
```


# 5. Versionsverwaltung im Team mit Branches

## 5.1. Erstellen von Branches

```sh
$ git branch <myNewBranch>
```
oder
```sh
$ git checkout -b <myNewBranch>
```


## 5.2. Arbeiten mit eigenem Branch (z.B. für ein Feature)

Zeige alle Branches an:
```sh
$ git branch -a
$ git branch <myBranch>
```
Pushen von <myBranch> zum origin. Durch -u reicht danach git push bzw git pull
```sh
$ git push -u origin <myBranch>
$ git branch -a
$ git pull
$ git push
```


## 5.3. Mergen von Branches

```sh
$ git checkout master
$ git pull origin master
```
myBranch in den master Branch mergen:
```sh
$ git merge <myBranch>
$ git branch –merged
$ git push origin master
$ git branch -d <myBranch>
$ git branch --delete <myBranch>
```


## 5.4. Demo 3

Erstellen Sie im GitLab/GitHub ein Repository/Project mit dem Namen „demo3“ und erzeugen durch Klicken auf „README“ ein einfaches „README.md“ file und klicken Sie auf „commit new file“.

```sh
$ git clone git@github.com/<my_user_name>/<my_repo>
$ cd <my_repo>
$ git checkout -b develop
$ git branch -a
(...)
$ git status
(...)
$ touch local.file
$ git add local.file
$ git commit -m “local develop”
$ git push -u origin develop
$ git branch -a
(...)
$ touch file2.local
$ git add file2.local
$ git commit -m “second local file”
(...)
$ git pull origin develop
$ git push origin develop
$ echo „Zusatz“ >> README.md
$ git add -A
$ git commit -m “ReadMe Zusatz”
$ git checkout master
$ git pull origin master
$ git merge develop
$ git branch --merged
$ git push origin master
$ git branch -d develop
```


# 5.5. Short-track für deploy a master release

Die folgenden Befehle zeigen wie der Branch develop in den master-Branch gemerget wird.
```sh
$ git branch develop
$ git checkout develop
$ git add -A
$ git commit -m “commit message”
$ git push -u origin develop
$ git checkout master
$ git pull origin master
$ git merge develop
$ git push origin master
```


# 6. Erweiterte Funktionen

## 6.1. Versioning/Releases

Die Verwendung von Git ersetzt nicht die manuelle Vergabe von Versionsnummern, da sich Commit IDs nicht als solche eignen. Eine sinnvolle Versionsnummer sollte für den Anwender der Software gut verständlich sein. Ein Schema, dass diese Anforderung sehr gut erfüllt ist Semantische Versionierung, die auf [dieser Website](https://semver.org/) detailliert beschrieben wird. Zu Grunde liegt die Idee der Rückwärtskompitabilität im Bezug auf die von außen zugänglichen Programmierschnittstellen. SemVer-Versionsnummern setzen sich aus drei Teilen zusammen, die immer dann und nur dann erhöht werden wenn entsprechende Änderungen vorgenommen wurden.

- Die Hauptversionsnummer bezieht sich auf Breaking Changes. Jede neuere Version der Software mit der selben Hauptversionsnummer soll ältere Versionen vollständig ersetzen können. Dass bedeutet, dass keine Schnittstellen geändert bzw. entfernt werden, sondern lediglich ergänzt werden können. Wenn solche Änderungen dennoch vorgenommen werden, muss die Hauptversionsnummer um eins erhöht werden. Für Versionen vor der Erstveröffentlichung, die noch nicht über definierte Schnittstellen verfügen, wird die Hauptversionsnummer 0 verwendet. Die erste offiziell Veröffentlichte Version trägt die Hauptversionsnummer 1.
- Die Nebenversionsnummer bezieht sich auf reine Erweiterungen der Software. Sie wird genau dann erhöht, wenn eine oder mehrere Schnittstellen um neue Funktionalität ergänzt werden. Dabei kann es sich um neue Funktionen oder neue Optionen für bestehende Funktionen handeln. Die Nummerierung beginnt mit 0. Bei jeder Erhöhung der Hauptversionsnummer beginnt die Zählung von neuem bei 0.
- Die Patchnummer bezieht sich auf interne Änderungen und Fehlerbehebungen. Sie beginnt wie die Nebenversionsnummer mit 0 und wird bei jeder Änderung der Haupt oder Nebenversionsnummer auf 0 zurückgesetzt.
- Vorabversionen können als solche gekennzeichnet werden, indem eine entsprechende Angabe mit einem Bindestrich angehängt wird. Zulässige Zeichen sind Ziffern, Buchstaben und der Bindestrich. Mehrere Angaben sind möglich und werden mit Punkten voneinander getrennt. Eine Vorabversion darf die Anforderung auf Rückwärtskompitabilität verletzen.

Es ist üblich im Repository jeweils einen Tag zu setzen, der marktiert welchem Commit eine Version entspricht.


## 6.2. Tagging

Mit Tags ist es möglich bestimmte Entwicklungsstände besonders zu kennzeichnen. Dies wird z.B. häufig für veröffentlichte Versionen verwendet. Es existieren einfache und annotierte Tags.


### 6.2.1. Lightweight Tags

Ein einfacher oder lightweight Tag besteht lediglich aus einem Namen und einen Commit Hash. Zum erzeugen:
```sh
$ git tag v1.5
```
Alle tags auflisten:
```sh
$ git tag
$ git tag -l <searchPattern>
$ git show <tagName>
```


### 6.2.2. Annotated Tags

Ein annotierter Tag verfügt zusätzlich über eine Beschreibung und die Information wer den Tag wann erstellt hat und kann signiert werden. Zum Erzeugen:
```sh
$ git tag -a v1.4 -m “Meine Version 1.4”
```

Alle tags auflisten:
```sh
$ git tag
$ git tag -l <searchPattern>
$ git show <tagName>
```


## 6.3. Signieren von Commits

Commits und annotierte Tags lassen sich mit [GnuPG](https://gnupg.org/) signieren. Dazu benötigen Sie einen PGP Schlüssel, den Sie mit `gpg --full-generate-key` erzeugen. Danach konfigurieren Sie git mit `git config --global user.signingKey <key fingerprint>` , diesen Schlüssel zu verwenden und aktivieren Signaturen global mit `git config --global commit.gpgSign 1`.


## 6.4. Submodule

Git Submodulen ermöglichen das Einbetten von einem git-Repository in ein Anderes. Im äußerem Repository wird eine URL für den Abruf und der aktuelle Commit des Submoduls vermerkt. Beim Arbeiten mit Submoduls ist es wichtig zu verstehen, dass es sich um getrennte Repositories handelt. Änderungen müssen seperat committed und gepusht werden. Achten Sie dabei immer darauf Änderungen an Submodulen zuerst zu veröffentlichen. Ansonsten referenziert ihr äußeres Repository einen Commit den Andere Entwickler noch nicht abrufen können.

Hinzufügen eines git Repositories als Submodul zum aktuellen Repository
```sh
$ git submodule add <URL>
```
Initialisieren des Submoduls
```sh
$ git submodule init <local_path>
```
Aktualisieren des Submoduls auf den geforderten Stand
```sh
$ git submodule update
```
Einschließen von Submodulen beim Klonen
```sh
$ git clone --recurse-submodules <URL>
```


## 6.5. Ändern der Commit-History

Sollten Sie Änderungen committed haben, die Sie so nicht veröffentlichen wollen, können Sie diese Commits noch ersetzen. Tun Sie dies **nicht**, wenn Sie die Commits schon gepusht haben, denn dies wird zu Konflikten führen. Verwenden Sie in diesem Fall neue Commits und eventuell `git revert`.

Sollten Sie eine Änderung zu einem Commit hinzufügen wollen, können Sie mit der ammend-Option des commit Befehls den letzten Commit ersetzen, der Ihre neue Änderungen ebenfalls enthält.
```sh
$ echo foo > file
$ git add file
$ git commit
$ echo bar > file
$ git add file
$ git commit --amend
```

Um den oder die neusten Commits aus einem Branch zu entfernen, verwenden Sie den Befehl `git reset`. Der Befehl verfügt über vier Modi.

- Mit dem Argument `--soft` wird es die Commits entfernen, die Änderungen die diese vorgenommen haven bleiben im Working Tree erhalten: `git reset --soft <commit>`
- Mit dem Argument `--hard`, wird es die Dateien dort auf den Stand des dann ausgecheckten Commits bringen und damit die Änderungen der entfernten Commits rückgängig machen. Der Index wird ebenfalls geleert: `git reset --hard <commit>`
- Mit dem Argument `--mixed`, dem Standard für `git reset` werden Änderungen aus dem Index entfernt, verhält sich aber im Bezug auf den Working Tree wie `--soft`
- Mit dem Argument `--merge` kann ein Mergevorgang abgebrochen werden. Das Verhalten ist ähnlich wie bei `--mixed`
Siehe dazu auch diese Frage auf [StackOverflow](https://stackoverflow.com/questions/2530060/in-plain-english-what-does-git-reset-do)


## 6.6. Cherry picking

Cherry picking bezeichnet in git-Terminologie einen Vorgang bei dem ein existierender Commit an einer anderen Stelle angewendet wird, als ursprpünglich vorgesehen. Dabei wird jeweils ein neuer Commit mit den gleichen Änderungen erzeugt, der auf dem aktuell ausgechecktem Commit aufbaut. Es ist außerdem möglich das automatische committen zu deaktiveren. Dieser Befehl ist beispielsweise hilfreich um einzelne Änderungen, wie etwa Bugfixes, von einem Entwicklungsbranch auf einen anderen noch gewarteten Branch zu portieren.
```sh
$ git cherry-pick [--no-commit] <commit> [<additional commits>]
```


## 6.7. Rebasing

Mit einem Rebase ist es möglich einen Entwicklungszweig von einem Ausgangscommit auf einen Anderen zu verschieben. Dabei werden alle Commits neu erzeugt. Andere Branches, die auf dem alten basieren, müssen ihrerseits von Hand auf den neuen Branch gerebased werden. Es können außerdem Konflikte wie bei einem Merge auftreten. Eine häufige Empfehlung ist daher das Rebaseverfahren nur auf eigene private, also nicht veröffentlichte, Commits anzuwenden. Es sollte daher nicht als eine Alternative zum Merge verstanden werden. [Dieser](http://blog.nerdbank.net/2020/01/should-i-merge-or-rebase-in-git.html) Blog Post zitiert eine Stellungnahme von Linux Torvalds, dem ursprünglichem Autor von git und dem Linux Kernel, zu dem Thema.


## 6.8. Merge/Pull Requests

Merge bzw. Pull Requests sind ein Feature diverser Git-Hoster, dass nicht Teil von Git selbst ist. Dabei wird der Maintainer einer Software aufgefordert Commits aus einem fremden Repository durch einen Mergevorgang in sein Repository einzupflegen. Dies ermöglicht es Code zu einem Repository beizutragen, auf das der Urheber der Anfrage selber keinen Schreibzugriff hat, bzw. Beiträge von Fremden anzunehmen, ohne auf Zusenden von Patches per E-Mail o.ä. zurückgreifen zu müssen. Nähere Information können Sie der Dokumentation des jeweiligen Anbieters entnehmen: [GitLab](https://docs.gitlab.com/ee/user/project/merge_requests/getting_started.html) bzw. [GitHub](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/proposing-changes-to-your-work-with-pull-requests).
