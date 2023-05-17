# About

This project contains the default wknd sample page.
This was extended with CICD automation on CirclecI ( any other platform can be easily be adapted) that
runs Product tests and Customer functional tests on ever PR on an RDE environment.

The validations can be easily be extended with other types like custom ui tests or lighthouse performance.


For demo purposes we added an integration test that verifies the title of the home page:
[PageTitleIT](it.tests/src/main/java/com/adobe/aem/guides/wknd/it/tests/PageTitleIT.java)

```
SlingHttpResponse response = adminAuthor.doGet("/content/wknd/us/en.html", 200);

Document document = Jsoup.parse(response.getContent());
Elements name = document.select("title");
assertEquals("WKND Adventures and Travel",name.text());
```




# script

checkout new feature branch 

```
git checktout main
git pull
```
    
Change the page title and push

```
git checktout -b demo
git cherry-pick fa47d2938dfe222db16e9464cb469d9ff00434b4
git log -1 -p
git push
```

got to https://github.com/andresbott/aem-guides-wknd/pulls and open a pull request
View CICD, it will fail.



Revert the change

```
git revert fa47d2938dfe222db16e9464cb469d9ff00434b4
git log -1 -p
git push
```


 