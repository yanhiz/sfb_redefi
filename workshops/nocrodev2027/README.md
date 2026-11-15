# NoCroDev2027 workshop pages

These pages use the existing SFB Quarto theme, navigation, and footer. Workshop-specific styles are isolated in `conference.css`.

## Editing

- `index.qmd`: conference overview, speakers, organizing committee, and important dates.
- `call-for-papers.qmd`: full call and abstract guidelines. Replace the “OpenReview submission link forthcoming” notice with the verified 2027 submission link when available.
- `programme.qmd`, `scientific-committee.qmd`, `further-information.qmd`: replace the notices as details are confirmed.
- `_header.qmd`: shared workshop navigation and wordmark.
- `_contact.qmd`: shared conference contact.

The workshop is included in the root `event_list.xlsx`, with links in its title and details. Maintain that entry in the normal event workflow. Quarto includes these pages through the root `_quarto.yml` render list. The underscored include files are not standalone pages.

Render from the repository root with `quarto render`. Generated pages go to `docs/workshops/nocrodev2027/`. Preview with `quarto preview`.

## Photograph and license

- Title: **Close Up Photography of Bird Nest**
- Photographer: **Evelyn Chong**
- Date taken: **28 February 2018**
- Camera listed by the source: **Canon EOS 5D Mark II**
- Source: https://www.pexels.com/photo/close-up-photography-of-bird-nest-907917/
- Download: https://images.pexels.com/photos/907917/pexels-photo-907917.jpeg?auto=compress&w=1800
- License: **Pexels license**, https://www.pexels.com/license/

`empty-nest-evelyn-chong.jpg` is a 1,800 × 1,200-pixel download of a real photograph of an empty nest, with no eggs or birds. The page displays it cropped and in greyscale using CSS. No generative image editing was used.

The Pexels license permits free website and banner use and modification. Photographer attribution is optional; the page retains a courtesy credit and links to the photo and license. Do not use the photo as a trademark or redistribute it as stock photography. The photo license does not replace the site's existing code license.
