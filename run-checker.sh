#!/usr/bin/env bash

cd "$(dirname "$0")"

echo
echo "☆☆☆ Rebuilding thin no flatten ☆☆☆"
# rebuild project: no flatten. hide maven output
{
/usr/share/maven/bin/mvn -DskipTests=true clean install -P thin-jar-noflat
} &> /dev/null

# run service in dry mode
rm -rf .m2-noflat
java -jar ./service-module/target/service-module-noflat.jar --thin.dryrun --thin.root=.m2-noflat
find ./.m2-noflat/ -name "spring-security-config*"

echo
echo "★★★ Rebuilding thin flatten ★★★"
# rebuild project: with flatten. hide maven output
{
/usr/share/maven/bin/mvn -DskipTests=true clean package -P thin-jar-flat
} &> /dev/null

rm -rf .m2-flat
java -jar ./service-module/target/service-module-flat.jar --thin.dryrun --thin.root=.m2-flat
find ./.m2-flat/ -name "spring-security-config*"

echo
echo "⍟⍟⍟ Rebuilding fat flatten ⍟⍟⍟"
# rebuild project: fat jar with flatten. hide maven output
{
/usr/share/maven/bin/mvn -DskipTests=true clean package -P fat-jar
} &> /dev/null

unzip -l ./service-module/target/service-module-fat.jar | grep "spring-security-config*"