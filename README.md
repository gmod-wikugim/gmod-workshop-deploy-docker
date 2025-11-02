Automatic deploy reposity to steam workshop for Garry's mod with 2FA support:
Example Repository: https://github.com/JTaylerJ/gmod-zen-framework/

Requirements:
- 2FA enabled on account (or workshop item will be hidden)
- addon.json in github repository (Get Addon Title from addon.json)

Optional:
- Support preview.png


You need setup github secrets in repository settings:
```yml
- STEAM_MAFILE - For get 2FA, you can get it using https//github.com/dyc3/steamguard-cli, from maFiles folder
- STEAM_USERNAME
- STEAM_PASSWORD
- STEAM_WORKSHOPID
```
Example:
```yml
- STEAM_MAFILE={"account_name":"kazah51261","steam_id":76561199580572133,"serial_number":"11374860396098266298","revocation_code":"R24875","shared_secret":"zlQK9RsQiGSW4qGtAE8UGmHnAfg=","token_gid":"71272ae56c3a374","identity_secret":"JjmHbZkUyrw0gzCjz4TUEZUL3yY=","uri":"otpauth://totp/Steam:kazah51261?secret=ZZKAV5I3CCEGJFXCUGWQATYUDJQ6OAPY&issuer=Steam","device_id":"android:9e0416df-51f4-4215-b93e-f7ef11c08f32","secret_1":"dkNGLwpyh7sBcEuOJD4zug7Q8VU=","tokens":{"access_token":"eyAidHlwIjogIkpXVCIsICJhbGciOiAiRWREU0EiIH0.eyAiaXNzIjogInI6MDAxNF8yNzJDM0M1Ql81MzhBOCIsICJzdWIiOiAiNzY1NjExOTk1ODA1NzIxMzMiLCAiYXVkIjogWyAid2ViIiwgIm1vYmlsZSIgXSwgImV4cCI6IDE3NjIxMDA0MTMsICJuYmYiOiAxNzUzMzcyNzc0LCAiaWF0IjogMTc2MjAxMjc3NCwgImp0aSI6ICIwMDA2XzI3MkMzNDFCXzdFNEQzIiwgIm9hdCI6IDE3NjIwMTI3NzQsICJydF9leHAiOiAxNzgwMzkwOTYwLCAicGVyIjogMCwgImlwX3N1YmplY3QiOiAiMTk0LjMxLjE0MC40NyIsICJpcF9jb25maXJtZXIiOiAiMTk0LjMxLjE0MC40NyIgfQ.fdnUw4x8ELnhNGquDgYScnaZn9XhAytIrRDasLfXWPS62E3-4gEL3arMn-4ieLJ7Dc2SwRo49HnuYdAZw7MaBw","refresh_token":"eyAidHlwIjogIkpXVCIsICJhbGciOiAiRWREU0EiIH0.eyAiaXNzIjogInN0ZWFtIiwgInN1YiI6ICI3NjU2MTE5OTU4MDU3MjEzMyIsICJhdWQiOiBbICJ3ZWIiLCAicmVuZXciLCAiZGVyaXZlIiwgIm1vYmlsZSIgXSwgImV4cCI6IDE3ODAzOTA5NjAsICJuYmYiOiAxNzUzMzcyNzc0LCAiaWF0IjogMTc2MjAxMjc3NCwgImp0aSI6ICIwMDE0XzI3MkMzQzVCXzUzOEE4IiwgIm9hdCI6IDE3NjIwMTI3NzQsICJwZXIiOiAxLCAiaXBfc3ViamVjdCI6ICIxOTQuMzEuMTQwLjQ3IiwgImlwX2NvbmZpcm1lciI6ICIxOTQuMzEuMTQwLjQ3IiB9.7x7Tos_gFrwJCBrPkrcaOOGO22K3v9gOgcFY4pXYeeHqk5zYQI6-Czh1k2kpxyHfdla4rabRcVOcGl4-4gsjCQ"}}
- STEAM_USERNAME=kazah51261
- STEAM_PASSWORD=CFD*npe0zkz0fma3cke
- STEAM_WORKSHOPID=3596528689
```



This is unable to publish items correcly, SteamCMD can't add tags to Workshop (Can be fixex in Crowbar)
At this moment not support multi-addons, changing directory

Github Actions
```yml
name: Upload workshop

on:
  push:

jobs:
  updateWorkshop:
    runs-on: ubuntu-latest
    container:
      image: jtaylerj/gmod-workshop-deploy:latest
      volumes:
        - ${{ github.workspace }}:/server
      env:
        STEAM_MAFILE: ${{ secrets.STEAM_MAFILE }}
        STEAM_USERNAME: ${{ secrets.STEAM_USERNAME }}
        STEAM_PASSWORD: ${{ secrets.STEAM_PASSWORD }}
        STEAM_WORKSHOPID: ${{ secrets.STEAM_WORKSHOPID }}
    steps:
      - name: Check out the repo
        uses: actions/checkout@v5
        with:
            lfs: true
            submodules: true
      - name: Uploading stuff
        run: /app/push.sh

```
