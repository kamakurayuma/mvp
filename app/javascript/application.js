// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

document.addEventListener("DOMContentLoaded", function() {
    const input = document.getElementById("board_image_input");
    const preview = document.getElementById("preview");
    const errorMessage = document.getElementById('error-message');

    input.addEventListener("change", function() {
        // 既存のプレビューを完全にクリア
        preview.innerHTML = '';
        errorMessage.textContent = ''; // エラーメッセージを初期化

        const files = input.files;
        if (files.length === 0) return;  // ファイルが選択されていない場合、処理を終了

        // 新しく選ばれたファイルに対してプレビュー処理
        Array.from(files).forEach(file => {
            const url = URL.createObjectURL(file); // オブジェクトURLを作成
            let element;

            // 画像の場合
            if (file.type.startsWith("image/")) {
                const img = new Image();
                img.onload = function() {
                    const pixelCount = img.width * img.height;
                    if (pixelCount > 17000000) {
                        errorMessage.textContent = '画像は1700万画素以下である必要があります';
                    } else {
                        // 画像が正常に読み込まれたらプレビューに表示
                        img.src = url;
                        img.style.maxWidth = "100%";
                        img.style.height = "auto";
                        preview.appendChild(img);
                    }
                };

                img.onerror = function() {
                    errorMessage.textContent = '画像を読み込めませんでした。';
                };

                img.src = url; // 画像の読み込みを開始
            } else if (file.type.startsWith("video/")) {
                // 動画の場合
                const video = document.createElement("video");
                video.src = url;
                video.controls = true;
                video.style.maxWidth = "100%";
                video.style.height = "auto";
                preview.appendChild(video);

                // 動画が読み込まれた後にURL解放
                video.onerror = function() {
                    errorMessage.textContent = '動画を読み込めませんでした。';
                };
            }
        });
    });
});

document.addEventListener("DOMContentLoaded", function() {
    const cameraMakeInput = document.getElementById("camera_make_input");
    const cameraModelInput = document.getElementById("camera_model_input");
    const suggestionsDiv = document.getElementById("suggestions");

    cameraModelInput.addEventListener("input", function() {
        const inputValue = this.value.toLowerCase();
        suggestionsDiv.innerHTML = ""; // 以前の候補をクリア
        suggestionsDiv.style.display = "none"; // 候補を非表示に

        // ここで既存のサジェスト候補をフィルタリング
        const suggestedCameras = [
            "Canon EOS R5",
            "Nikon Z6",
            "Sony A7 III"
        ];

        const filteredSuggestions = suggestedCameras.filter(camera => 
            camera.toLowerCase().includes(inputValue)
        );

        // フィルタリングした候補を表示
        filteredSuggestions.forEach(suggestion => {
            const suggestionItem = document.createElement("div");
            suggestionItem.textContent = suggestion;
            suggestionItem.onclick = () => {
                cameraModelInput.value = suggestion;
                suggestionsDiv.innerHTML = ""; // 候補をクリア
                suggestionsDiv.style.display = "none"; // 候補を非表示
            };
            suggestionsDiv.appendChild(suggestionItem);
        });

        // 最後に「不明」を追加
        const unknownItem = document.createElement("div");
        unknownItem.textContent = "不明";
        unknownItem.onclick = () => {
            cameraModelInput.value = "不明";
            suggestionsDiv.innerHTML = ""; // 候補をクリア
            suggestionsDiv.style.display = "none"; // 候補を非表示
        };
        suggestionsDiv.appendChild(unknownItem);

        // 候補が1つ以上あれば表示
        if (filteredSuggestions.length > 0 || inputValue !== "") {
            suggestionsDiv.style.display = "block";
        }
    });
});
