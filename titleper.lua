--
-- mpv bring back slash in title v0.6.0
--   ( copy me to ~/.config/mpv/scripts/ )
--
-- required binaries:
-- youtube-dl   - https://youtube-dl.org/
-- xdotool      - https://www.semicomplete.com/blog/projects/xdotool/
-- xseticon     - http://www.leonerd.org.uk/code/xseticon/
--      (debian - http://packages.leonerd.org.uk/dists/unstable/ )
-- jq           - https://github.com/stedolan/jq
-- luasocket
--

local utils = require 'mp.utils'
local msg = require 'mp.msg'
-- local patched = 1

mpv = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACvklEQVQ4y3WTSWhUWRSGv/MmU1UpwYSoFbs0VXFo7IhTowgaJGrEhbYLFw44LNqFjWD3Og3dLsSFLlwILgRbXShuXPRCEcUhEUQRIyZROnGImipRkjhVXr2q9+69LrpSiMOBs7nn8t9z7v8d4esQwKqkVM4MoCtpvrz8edhL61obG+KTf3fEaReRZkFcbfRAaKKLw/6bI7dHO/OA+paAuza1YWvcTRwVpPYbnWEwBT8c23vp1b9ngBDArtSc9tT67bVu8h9BPICmWRl+Xr2YzNwMumx4P/oOQTzP9jam401PnxT6ewEtgCyZtHz2tGT6niDxmpoYew79yoK2FrTWKKXQWtN9tZcTf56mFAQYjJ/7+HLRnbc3+y3ArY817BMkDrDn8G4WtLVw8q+zvBkaRmuN1pp5rT+y8++tlbklXh9r2Ae4FjDBs712gMzsLPNXzkUpxcDdJxz57RgXTl4h8EsopfhpxRx+yKQB8GxvDeBZgGuJ1QQwc1G2+mIYhRT9IhdPXWL/joN0dz1AKcWMef8LWGJlAM+p+B0CtjGmKhCUivgln6BcxC5bRGGE1hqjqxiEgOUARhmVd8TJPu5+Wv20QlBAmYg1m1exdlsbtmujtWaw9wUAyqg8YBwgKoZ+V9KbmB3sf8b9a320rJjDzIXNbNr7C/VTJ1W76rnxiPxgDoBi6HcBkQ1YEsnrKYnUFkGcns4+UtkU63atJpaoqVrZd/M/zh08j1IKgwkejfT+8TYaGZIKTHXL6lfuTiUaD4wPmG6ezoyWNNponve8JPdsqErkq7F8x62R68eB0XGUJwBTlta17misndYhSM13UA7yhdyB26Odp4HXQGkcZQ2Uc8XnA37gX4u5cXEsJ2mJFQNUpKOhD+X3F/pGHnQ8LNy/DAwDpS+XSQAPSAITgQTgfmbZGPAB+AiUx9f6E25gOc5E3m0HAAAAAElFTkSuQmCC"
youtube = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAASpJREFUOI3Fj7FKAwEQRN+ud7nLiUlIIXikDwiS3iLp9ENsrvYLtBFSCfmBfMHVYhtsbWwsrVKqJEjMJWHXRkTCRSQITjkzOzML/w15bLf3oji+Vvdjc28o7KIaGYQKCmBgCkvM5gYz4FVE7mI4D6pxfAGcIYKKfCXrt5bPoAjVSKEOHACHBTyrw8m28w1O1SEtE/cHA4JW68cAhVQxq5WJ1W6XNM9pZBkSReULzGqqqsGmBoki6llGmudUe70yS0XL2FK4l9KBma02rfCiYDIcMh0O8aIosywCVKdAc115H4146fdZjccbR6nqVJ46nQeBo1+9sQaDewVutzkGEPebIFkuL2dhWBGzLiJNd09QjQVCgxBAYeWwwGwu8IbIxEVGO0lytW353+EDEcdb/8vRttIAAAAASUVORK5CYII="
facebook = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA3XAAAN1wFCKJt4AAABp0lEQVQ4y5WTPWtUQRSGn7l37r0M7qIJQrSwyIKdaLFIFBHsNSpYiZ0gqcTKYkGwDGppIWns7Az4C8RGREVsJWWw3mxMsnM/ZuZYrLt3sx/InmrOvOc8c15mRrVuvXwiIpsiwbBAKBVZpVRHrd580b98dc0sn2pi0pgsiUh0RBIrlFIIQgjgfKCoAnnpsaWn2zvg57fvVosEc7Jp+LW7t8gAtM42EAlGA6SxIMHNLFxqpty5co7rF1ZYPdPgMHfcfv4Rkwx0DaAjIfjZgGf327TPnwZg76AgTWKCd2Ra1YCI+YCLrWUAHr76xM7vfZQCkcHUI4AiTFn4/Presfzt0xsAXHu8PWiMxyxI8HMnmIxhXcTYBM65KcDaxjsAvm49OJaP3oGEGlCV1dxbGMak7oOvAXlZ/tfCpF5VVQ3o24LgHRt323MBj9YvjdZbH36QF+U4IEe8Q/75mmlhTBPvsLaoAUd9SwiON++/TDXO2hseOgTY/T9HZqmRccKkmCzBZAlZqtFxRBxHKCCI4L1QVI6ycnR7hwBWK+h0e/lmt5cv9J0Bq6DzF87Qyjqp0GJ2AAAAAElFTkSuQmCC"
twitch = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAApUlEQVQ4y2P8//8/AwMDA0Oq0zIIg0TAxMDAwHB8932yNDMwMDAw/v//H8X22fuiiNKY6rQM4QJKAF4DDm+9A7cJmU20ARS7gC4GsOCTtPVWYbD1VsFgU+yCLYuvkG/AlsVXGDbOv8TAwMDA0LrIF9MLyFEFS1TYoq91kS+DmAwvIxOxKQ6bZoJeIKQZnhewaEQRzG62YzCwlmEkKx3g08zAwMAAAL2DN6b39LbLAAAAAElFTkSuQmCC"
nicovideo = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAWlBMVEUAAAALBQULBQULBQULBQULBQULBQULBQUAAAALBQUAAAAAAAAAAAALBQULBQUlIiI4MzMLBQVbV1dfW1tXUlINDQ0GAQELBQULBQWNiYmppqYGAQELBQX///8+nAgGAAAAGXRSTlMAM0RV7iLdd2aIMyKquxGq7szd3d3d3apmrrtdgAAAAAFiS0dEHesDcZEAAAAHdElNRQfcCQQEOTLqAPc0AAAAZklEQVQY04WOSRKAIAwEE5CouO8K/P+dRi0F8WAfpmq65jAADAqfJzJBAEXpIyAjVJTfTWtdlESVQsSae7MZY1rrEsd0LHoXwmL4FWMspljMNhJk7Vss4eD4AUJSJ8SV9XV+lT4/7CTGDlT+wIUFAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDE4LTAyLTA3VDE2OjAwOjQxKzAxOjAw7RzbywAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxMi0wOS0wNFQwNDo1Nzo1MCswMjowMJ7d5OsAAAAASUVORK5CYII="
indavideo = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAe1BMVEXeMSjdMCjcLyjcgH3+/PznurjaLifqxsb////aNS/YLSfWRkHltrXWWVXWLCfUVFHdl5bVWlfUKif8+Pj9+/vSKSbQKCbOJibOLCzMJSX9+vrbmpvVgYHKIyXoxsb58/PIIiXJP0Hox8f//v737e3QcnTGISXEICTDHyRix4+hAAAAAWJLR0QIht6VegAAAAd0SU1FB94CBg4QF3jEYd8AAABpSURBVBjTXcrJEoJQEEPRMCgNCsqMKDKj//+FvErv+qxupQJYngGfgvCi4eNKkUishYRu91QjQUaPZ66RoaBSKo0CNYmIRo2G3KDRoCU3dFp4US/y/rAw0NddRhYmmpd121k4DPwM/I0TWq0TTsn4eO4AAAAldEVYdGRhdGU6Y3JlYXRlADIwMTgtMDItMDVUMTI6MDQ6MjErMDE6MDBlgT3DAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDE0LTAyLTA2VDE0OjE2OjIzKzAxOjAwKvdFhAAAAABJRU5ErkJggg=="
streamable = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABU1BMVEUPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoNj/oPkPoNj/oNj/qExv0PkPpruvwPkPornfoVk/opnPpnufwPkPqExv0Nj/oPkPoNj/oPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoPkPoOj/opnPsVk/oMjvoOkPoTkfo6pPsblfo3ovva7v7////v9/5Sr/whmPry+f5htvze8P7W7P5itvyl1v0imPu84P3o9P50v/zN6P73+/8lmvs8pfs+pfsKjvr9/v9EqfsNj/oom/v8/v9nufxAp/tJq/sQkPrb7v6t2f0IjPoclvr6/f9luPwUkvrp9f7h8f5ruvy/4f4kmftpuvwxoPum1v32+/8jmfpMrPvu9/7z+f9UsPs7pPv8/f/4/P9oufwalfpDqPsMj/ounvtVsPsnm/oX4FZeAAAAAXRSTlMAQObYZgAAAAFiS0dEAIgFHUgAAAAJcEhZcwAACxMAAAsTAQCanBgAAACzSURBVBgZBcExS8NQGEDRe19SzPcqdFBwsISiWR39/wiODk4OQgliRUToYCTE5mk9RwBUdAYQ8OQKgN4RhNMWAIDXgQo6AABYzVNNIKpqKeLZhY2qxdrv3486cWxUVV2+pbRnfVju8xQREaEJgtjEZc59REAt0anbzlv1aJIh5+e4yfkp4kGrv8W0OF8/tvfXbX1X3j8lbwAAgK9dxTytAAAYdlRwyGMDwFheQAA61Z8e4B9zfC+56atCOAAAAABJRU5ErkJggg=="
soundcloud = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABJlBMVEVTKwBuOABuOQBVLACmVQD7ggD9fgL8ggCrWAA0GwDreQD8eQT8egTuewA8HwDqeQDuewCiVACtWQD6gQBOKAD9fQJXLQBmNQBzOwBzOwBNJwD9fQJWLAD5gQD8ggChUwCqWADoeADtegAzGgDpeADsegA5HQCiUwD5gQD7gQCmVgBPKQBrNwBsOABRKgD8eAT4Zwv3Yg77dAb3Yg33byP6r4T7y7D5ll73YxD4ikz5o3L7vZr96t/+/v79/f35k1r3dSz4jE/6upb7yq7807397eX85Nb6t5H3ax37xab7v57807z82sj84ND98er6sIf4eTL6roP6rID6uZX7yKv7z7b97OL9+/n5jlL3ZhT3Zxb3aBj3ahr3byL3cyj8eQT7cwb///8h/uObAAAAAXRSTlMAQObYZgAAAAFiS0dEAIgFHUgAAAAJcEhZcwAACxMAAAsTAQCanBgAAAAHdElNRQfiAggPNyX4c1joAAAAoklEQVQY02NgwApY2fT12djhXC5uA0MgMODhhfD5jYwNwcDYSAAswA3lA0W4QXxhsHoTUzNzoC6QOaKGhhaWVtY2tnb2hoaiQAF9CwdHJ2cXV1tbN3cPfZCAo6eXt4+vny0Q+IMEpAMC4JDQsOA/PAIkBZZA4vIqOiY2Li4OA8DOZA18WjWMigmwByWoARxqko8xOncqnDfaEjr60trYvc4APJjIbHFY3ZEAAAAAElFTkSuQmCC"
bilibili = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAb1BMVEUAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodYAodb///8pppHuAAAAAXRSTlMAQObYZgAAAAFiS0dEAIgFHUgAAAAJcEhZcwAACxMAAAsTAQCanBgAAABSSURBVBjTbY5BDoAwCAT35slGE2PCefv/N4rQIKXOZelACcAPpOc2UgumAHYGzT9kTu1fPXjXkT0xBMTaEsKnvDIhJuQTy45J3MQsymEqjvKuPAU5GU4j4T2TAAAAAElFTkSuQmCC"
vimeo = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAnFBMVEUAre8Are8Are8Are8Are8et/EKsPA0vvJRx/QJsPAHr++O2/j9/v+66fuX3vj///+b3/kOsvC+6vv+//8YtfE7wPPz+/7T8fwctvFozva05/pLxfQiuPGv5fo/wfN41PdTyPQFr++o4/rV8fy46Puw5vr3/P7N7/zr+f4atfFmzvX1/P5AwvMNsfDs+f7w+v5Dw/M6wPOC1/cbtvFA3hZnAAAAAXRSTlMAQObYZgAAAAFiS0dEAIgFHUgAAAAJcEhZcwAACxMAAAsTAQCanBgAAAB9SURBVBjTXc/XEoNQCEVRVKLp2zTTe+/t//8tyVwzojwww3qAg4inpjwRXzUvWigHpfDbonIlhWqt3lBtQuyg1YZOt5dA38FgOIKxTmD63zGDuS5+msIyYRWu2WRXtuz2HI4ZnIDzxeS43rg/bDB9vt65pDZ64TlfJLBzIB+3HwlaT7LyVAAAAABJRU5ErkJggg=="
cmovies4u = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7CAAAOwgEVKEqAAAACKUlEQVQ4y42TvWtUQRTFf3d289WINlEQTKLJe5v3ZlcQgnYpEpUgIgjqPxCx0VpERAQLLazEMjZqY4IgiKAhWtjYCEneV97bfCE2YiEGI64JMxYbk4mFcbo595x7D3PuCMDbwUH2fvpMsDAHQOQHVwQZBroAAywCL3WePASIvJBqkQAgcRAga1bCemYjP7wscJ9/HGPsuVo9nYj9UHSeWGXXhQ3x053EAErJeOSHd3We2NgLkKbl8KrAHZdo4THYKSwiIieBC1slBGvO6yIbl5luv1xqK685wpWfvxqdA0vzDbdhWvF2GdvyBWj9g+k8EaXayje2T7adA0vzjaS7skmM/YBgrlgpG7PP5UZecFEJnHCmP6rlaQPAtJUexH44HXvBEZ2nAFTq2Vfg+R++iIwooMeZP7VZhO/AYUQ+xH5YJF7/UJNi3jgmepSl+ZAAYik5btodYp8RNRH19h+zoqyDixJY3rrKKcdBhwWstS/A6mqe7KnOZ+8FzjgNlpVrGzib9vqdTQfmWWtLR3u1SE/rPE2aceuDwJDDfy0zfthRgh/blsWsdwX1/KOLzXphRQmZi+k8EdmI6TbI9b+W7p2FSQEFdgTk6La4rR2tFumYxH0Bup4Se8EkIsP83xnTeTI6W9EoWiA+VBFdpMeBmzsprTWXdJ6MpkFNqnNxM8LpWo3W1TWChYzFgf2l1W+7r4nYIZADG995yVjzqlZk9wCK/ipPsohbwG/rQNgUynZ/zAAAAABJRU5ErkJggg=="
usatoday = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAaVBMVEUAZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/8AZ/////9YL4h4AAAAAXRSTlMAQObYZgAAAAFiS0dEAIgFHUgAAAAJcEhZcwAACxMAAAsTAQCanBgAAABaSURBVBjTY2DAChiZFBWZkfjsimDAAeNzK0IBD4TPrwgHYDWMikgAJCCILCAIFEDmKwqhC4D0iCDzRYACosgCYiBThRB8qENQbQUBaQhXBuEZeaDnFLD7mwEAVMcSAw8xNXkAAAAASUVORK5CYII="
videa = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAB30lEQVQ4y42TMWhTURSGv3PvS0JBkr7YooNUKJWCkzYiFjJ1KOjQgiiCUEU3BxHcpJNdReggCh0LdbHg7iYUIkIgUIhDpVJoJdCSNCHtS9Pcex1eEpO0KT3budzz/+c/5z/QJ4p+KsE5QnqK0ljmjbK3NSoJgCXjFKsNL1i6tJuv9gUoDqbmjZi3Gq1PYzLYoka9TJayn08AFAdvzSFu+TwtO/ja8IInrW7E8VDvxTc2tdYjAN6dG0Qf3QOg8SOHHh9F/DgAwZv3uNoRWDIo7iZL2bJX8jcnNWExQGQ6Tezp/VD+1l8i02n09bEQYOED1I5AMelwy8CswrlUZ4utzwAm/xu06jN9mSklJqaUE4bPAlAX/WZicQdBF4hVMqPESbSNGr+AunI5HFYl3JgM+U05O1A/7h6otVHlhEKbfezqf/TtArHnD9r58be1kzIU3z1xkkVc+DIQ65LSkuMqVWofV7p9YczaUOXaqvL3DzNYU2itrZfJ5H5RmZrDbhc6xJtCBHkmfDFNI028QmSxzT4+CgMx7MYW7uCwl3ndk+isX/75p8vKe4mbK0qpx/0caKCuHQv+fvBOyNf7HdMLB68FOnbJDopPXsMsxau53TOvsQNoRFk3nCjX1jvZTot/Ft663C517noAAAAASUVORK5CYII="
twitter = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAABw0lEQVQ4y8VTS0sbURg9k5m8R2bGMFGjpGNkXLgw04UggiX5BQn4A+KUri30DwiFLlwZQXAhmFm5kBYNiNWV8bUp2CaL0kKFCIIORToTTcukExkXOiGvWbnwbL57ud85l3O/cwnLsvAUuPBEUPZCM0yG87kr7Q2aYTJK8ULWDZMTWH9ZlqKKZpgMAHA+d4WwLaQ3TvOpUX5TlqJKs4C0elws/ffH4aIAs4YEUy+Ub2rD86/E93J8aK1hQe/pG3h9qObkfDFn3/BNrUilgBBHfwwIR4FBEQUiktAjY6GXEe68xUJGZLcP/gUnlOvfs1vLhVRa5PMMHfgLH9/qKchAmQx8kHjvFwBoWEh++nFSQP8UAOCuDtz+eaihSMfDWTMcD+C6ZQqLydgSQ6EKACApgA13JUsseWaTWwSkXu/O2xHPx4aIA+YEct0pB9UEZ+0KPkt1IksseSaPBFccg5QcpHdzE/R8esB91I28P02/AaB2BEkzTObd3vfs1s+rlE54OYSjQE+o0ZR54fmcHfcvsB7XcbuwPQUSgFjU65Obl2bSPhQCLjXBU1+Hg2QJwC8Ad04CNmgAoaZ9DYD2WLuCePbfeA8Zz5X+zJnRrAAAAABJRU5ErkJggg=="
dailymotion = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAABvUlEQVQ4y2WTMW8TQRCFvze3joONcGzsFJEMZYRFC2mSMh1CSGn4F0j8BH4Av4AuoqChBEFDAQ09oaZBpMABlMgC+W6H4tZ75+Sk1e1oZt6+eW9XfPrr4CDqhYPRxHKgFdt6HIirxvRJ4AkIwNWAAFRqQADDU1H7z6U9ECRudcT+dWNYWKqvya43OBBp9g5EMSnEs50OH3c3ud9rAAIxUcxjqKEfBe4gJ3TF7Fp9nseUMwh1bWrKvYLoPBgbBwNjEeHLInJeJrLQYuBt8VYnw4vdDo/GxigIAfPSCdKVcS1zjylRwdNpweNJwc0gPvyJPP9eclHBoMiCZetCFkoJBPFwZPQLeD2vODopwZzjnxXvZhtsd7QmruWZk41bAXpFjf7+LOYD50txsvArFltGSyC/l/BrWWePxgW3u2IYxL2+uNtTM0EjYss2ARUcn0b2t4zDofHqTuDbP+dgYEw6ymV47VRo37aak3j5wxmFiidTY++GsQd8XTiVO9OusNXIEuLt0tceTmJZFM6sL7Y3RIlzuoRNc3a64vOFc1bG5OGb0vNjsRbI6mZezuV9HbcuUkvMlVJqWZwo16mm6T9GA7W+24Z5pAAAAABJRU5ErkJggg=="
--
-- to make your own icon: base64 favicon-16.png |sed -e 's/\(.*\)/"\1" ../'
--   base64 favicon-16.png |tr -d "\n"
--

myoutfile = "/tmp/mpv-favicon.png"

local ltn12 = require "ltn12"
local mime = require "mime"

function writebase64(mystring)
ltn12.pump.all(
  ltn12.source.string(mystring),
  ltn12.sink.chain(
    mime.decode("base64"),
    ltn12.sink.file(io.open(myoutfile,"w"))
  )
)
end

function os.capture(cmd)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read "*a")
  f:close()
  return string.sub(s, 0, -2) -- Use string.sub to trim the trailing newline.
end

function get_title(url)
  return os.capture( 'youtube-dl -j "' .. url .. '"| jq -r \'.title+" @"+.uploader\'')
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function on_loaded()
    local title = mp.get_property("media-title")
    if ( string.find(title, '/') )
    then
	msg.warn("title on_preload matched")
	cmd = { args = {"sleep", "0.1"} }
	utils.subprocess(cmd)
	mp.set_property("file-local-options/title", title)
    end

    filepath = mp.get_property("path")

--    if ( (filepath:find("http") ~= 1) and (filepath:find("ytdl") ~= 1))
--	then return end
--    msg.warn("http matched " .. filepath)

    if ( filepath:find 'facebook.com') then writebase64(facebook)
    elseif ( filepath:find 'yout') then writebase64(youtube)
    elseif ( filepath:find 'soundcloud.com') then writebase64(soundcloud)
    elseif ( filepath:find '^https?://[www.]*twitch') then writebase64(twitch)
    elseif ( filepath:find '^https?://[www.]*nicovideo.jp') then writebase64(nicovideo)
    elseif ( filepath:find 'indavideo') then writebase64(indavideo)
    elseif ( filepath:find 'streamable.com') then writebase64(streamable)
    elseif ( filepath:find 'bilibili.com') then writebase64(bilibili)
    elseif ( filepath:find 'vimeo.com') then writebase64(vimeo)
    elseif ( ( filepath:find 'cmovies4u.com') or ( filepath:find 'oloadcdn.net') )
	then writebase64(cmovies4u)
    elseif ( filepath:find 'usatoday.com') then writebase64(usatoday)
    elseif ( filepath:find 'videa.hu') then writebase64(videa)
    elseif ( filepath:find 'twitter.com') then writebase64(twitter)
    elseif ( filepath:find 'dailymotion.com') then writebase64(dailymotion)
    else writebase64(mpv)
    end
    if (file_exists(myoutfile))
    then
	msg.warn("website icon use")
        cmd = { args = {"sh", "-c",
	    "xseticon -id $(xdotool search --sync --onlyvisible --pid $PPID) " .. myoutfile } }
        utils.subprocess(cmd)
	os.remove(myoutfile)
    end
    if not patched
    then
        newtitle = get_title(filepath)
        msg.debug("filepath: " .. filepath)
        msg.warn("newtitle: " .. newtitle)
	mp.set_property("file-local-options/title", newtitle)
	mp.set_property("file-local-options/force-media-title", newtitle)
    end
end

mp.register_event('file-loaded', on_loaded)
