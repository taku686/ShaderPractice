# ShaderPractice
 **--水面--**
 
 **・キューブマップを使用して空が映りこむように表現した。**
 
 **・フレネル反射で角度によって反射の仕方が変化する**
 
 **・カスタムレンダーテクスチャーを使用してタップした箇所から波紋が発生する**
 
![water](https://user-images.githubusercontent.com/74074598/210936835-061820dc-f6bf-4623-9561-9ea87f1f1797.gif)

**--ワイヤーフレーム--**

![WireFrame](https://user-images.githubusercontent.com/74074598/210950686-2485eea1-a131-47a8-aa3b-b9225df862cd.gif)

**--ワイヤーフレーム-対角線なし--**

![WireFrame_Diagonal](https://user-images.githubusercontent.com/74074598/210950695-fb029c14-c491-4e34-aa8c-d24b9ce68aa5.gif)

**--色収差--**

**rgbのuv座標をそれぞれずらしている**

![Aberration](https://user-images.githubusercontent.com/74074598/210950697-0884b528-62d5-4a38-89f6-94ffad954fc5.gif)

**--rgbのuv座標をランダムに動的にずらしている--**

![Distortion](https://user-images.githubusercontent.com/74074598/212239796-644b65fe-e762-47d3-aaf1-0ea9f28cf7be.gif)

**--ジオメトリシェーダー--**

**ジオメトリシェーダーを利用してプリミティブの変形**

![Extrude](https://user-images.githubusercontent.com/74074598/210950718-fc622f3d-74e0-4087-b2c9-c36f3d5f2abd.gif)

![Pyramid](https://user-images.githubusercontent.com/74074598/210950758-e1daef44-ffd2-4076-a1e4-aa714604c9d6.gif)

![Pyramid2](https://user-images.githubusercontent.com/74074598/210950768-8110631d-efe3-44ee-ad42-f29d53fab577.gif)

**-旗-**

**ランダムな値を入れることでリアルに旗がなびいてるように設定**

![Flag](https://user-images.githubusercontent.com/74074598/210950734-6231a12b-c6fb-4087-af62-c294772ac1d5.gif)

**--切片--**

**複数回パスを設定することで本来描かれない裏側を描画している**

![Section](https://user-images.githubusercontent.com/74074598/210950775-04f17d76-0d12-4ea4-9e5e-bd1d4aa16ff3.gif)

**--ステンシル--**

**ステンシルバッファを利用することで壁の後ろ側にいる物体のシルエットを表示している**

![Stencil](https://user-images.githubusercontent.com/74074598/210950780-267e6310-5d8c-4210-9175-d45112bb9c3f.gif)

**--トゥーンシェーダー--**

![Toon](https://user-images.githubusercontent.com/74074598/210950781-0095afa9-e6d8-4664-912a-d120a47e72c7.gif)

**--回転--**

![UVRotation](https://user-images.githubusercontent.com/74074598/210950784-5eb78df9-fadf-46f7-9252-8e5eab67b7b4.gif)

**--ステンドグラス--**

**GrabPassを利用することですでに描画してある画像を利用して、窓ガラス越しの屈折を表現した**

![Window](https://user-images.githubusercontent.com/74074598/210950812-951fd2d2-cb93-4944-9719-749b9267ffbf.gif)

**--アニソメトリック--**

**鏡面反射に方向を持たせることで床に光が反射しているように表現した**

![Anisotropic](https://user-images.githubusercontent.com/74074598/210951296-cef213ad-c209-4f54-91fd-3661ef9cdf37.png)

**--ファー--**

**動物の毛のような表現**

![Fur](https://user-images.githubusercontent.com/74074598/210951299-3cb1b549-ef69-4ccc-ab8a-79cb88ac9f90.png)

**--ポストエフェクト---**


![MonoTone](https://user-images.githubusercontent.com/74074598/210951303-9727b58c-a705-4a5c-8e54-a563daecdb10.png)

**--アウトライン---**

![outline](https://user-images.githubusercontent.com/74074598/210951306-85ed28fc-e7ae-4f10-9ffd-71eb27240d8e.png)

**--ホログラフィック--**

**リムライトで輪郭を強調させ、中は半透明な表現をしてある**

![RimEffect+Transparency](https://user-images.githubusercontent.com/74074598/210951309-4fa598c8-ef69-42fd-a3d0-c1eac5f17c47.png)

**--モザイク--**

![TriangleMosaic](https://user-images.githubusercontent.com/74074598/210951311-d9a9cfd8-2357-4abb-9b3e-6afdaabf2813.png)

**--Ambient(環境光)--**

![Ambient](https://user-images.githubusercontent.com/74074598/210951313-7bd8b83a-2f94-4359-96f9-8054941618b2.png)

**--Ambient(環境光)＋Diffuse（拡散光）--**

![Ambient+Diffuse](https://user-images.githubusercontent.com/74074598/210951315-91da723a-156e-4be2-81d9-1081f18e2bf7.png)

**--Ambient（環境光）＋Diffuse（拡散光）＋Specular（鏡面反射）--**

![Ambient+Diffuse+Specular](https://user-images.githubusercontent.com/74074598/210951319-80b80902-4e34-4984-a0aa-05c2f1ef9d3d.png)

**--Ambient(環境光)＋Diffuse（拡散光）＋Specular（鏡面反射）＋Emission（発光）--**

![Ambient+Diffuse+Specukar+Emission](https://user-images.githubusercontent.com/74074598/210951317-92f15e11-869d-4c1e-9d38-918ead87663e.png)

**--花びら--**

![Flower](https://user-images.githubusercontent.com/74074598/212239736-9a28ee06-ca72-4ae4-904b-e9d4a949596c.png)


**--uv座標移動--**

**--ハートの形の関数を用いた--**

![Heart](https://user-images.githubusercontent.com/74074598/212239798-0ce94cbd-a047-4c47-b531-ba6865defe3d.gif)

**--uv座標の繰り返し処理を用いた--**

![Repeat](https://user-images.githubusercontent.com/74074598/212239803-8557efaf-be75-4db9-a591-30680f9d7413.gif)

**--ランダム--**

**--セルラーノイズ--**

![CellularNoise](https://user-images.githubusercontent.com/74074598/212239810-1e01b59c-c080-4b19-bba4-e12c3068e877.gif)

**--レイマーチング--**

![RayMarching1](https://user-images.githubusercontent.com/74074598/212241192-60f89090-6980-4b33-882b-bdc84777ff8c.png)

**--レイマーチング＋レイトレーシング--**

![RayMarching+RayTracing](https://user-images.githubusercontent.com/74074598/212241195-bcf66515-b75a-4a7d-8bfe-1794a042e7c1.png)

**--レイマーチングを利用してスライム状のものを作成--**

![Slime](https://user-images.githubusercontent.com/74074598/212241867-f17dc28c-e94c-4138-a075-402715527109.gif)
