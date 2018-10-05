---
title: "Objectives"
permalink: "/objectives/"
layout: "default"
---

{% for toc_entry in site.toc %}
  {% for lesson in site.en %}
    {% if toc_entry == lesson.permalink %}
## [{{lesson.title}}]({{lesson.permalink | relative_url}})
{% for item in lesson.objectives %}-   {{item | markdownify}}{% endfor %}
    {% endif %}
  {% endfor %}
{% endfor %}
