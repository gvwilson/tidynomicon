---
title: "Learning Objectives"
layout: default
permalink: "/objectives/"
---

{% for toc in site.lessons %}
  {% for page in site.en %}
    {% if toc == page.permalink %}
## [{{page.title}}]({{page.permalink | relative_url}})
{% for obj in page.objectives %}-   {{obj | markdownify}}{% endfor %}
    {% endif %}
  {% endfor %}
{% endfor %}
