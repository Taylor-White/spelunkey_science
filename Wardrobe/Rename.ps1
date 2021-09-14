
$current = "D:\Program_Files (x86)\Steam\steamapps\common\Spelunky 2\Mods\Packs\Wardrobe\wardrobe_skins"
$i = 0
cd $current
echo $current
$files = Get-ChildItem $current
 foreach ($f in $files){
    $new = "$i.png"
    echo "$new"
    Rename-Item $f -NewName "$new"
    $i++
}
