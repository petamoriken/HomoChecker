<homo-content>
    <div class="wrapper">
        <div class="loading" if={ !items.length }>
            <i class="fa fa-refresh fa-spin"></i>
            ホモを集めています...
        </div>
        <homo-item each={ items } data-duration={ status === "ERROR" ? Infinity : duration } />
    </div>
    <style type="text/scss">
        homo-content {
            display: block;
            padding: 20px 0;
            font-family: Helvetica, "Hiragino Kaku Gothic ProN", "ヒラギノ角ゴ Pro W3", Meiryo, sans-serif;

            .loading {
                text-align: center;
                position: absolute;
                top: calc(50% - 2em);
                left: 0;
                width: 100%;
                color: #444444;
                font-size: 18px;

                .fa-spin {
                    vertical-align: -5px;
                    margin-right: 3px;
                    font-size: 36px;
                }
            }

            .wrapper {
                margin-left: auto;
                margin-right: auto;

                @media (min-width: 768px) {
                    width: 700px;
                }
                @media (min-width: 992px) {
                    width: 930px;
                }
                @media (min-width: 1200px) {
                    width: 1130px;
                }
            }

            @media (max-width: 767px) {
                padding: 8px 8px 0;
            }
        }
    </style>
    <script type="es6">
        import Shuffle from "shufflejs";

        this.items = [];
        this.on("mount", () => {
            this.shuffle = new Shuffle(document.querySelector(".wrapper"), {
                itemSelector: "homo-item",
                speed: 150,
                easing: "easeOutElastic",
            });
        });

        this.on("updated", () => {
            this.shuffle.add([ this.root.querySelector("homo-item:last-child") ]);
            this.shuffle.sort({
                by: elm => +elm.dataset.duration,
            });
        });

        const source = new EventSource("/check/");
        source.addEventListener("response", event => {
            this.items.push(JSON.parse(event.data));
            this.update();
        });
        source.addEventListener("close", event => {
            source.close();
        });
    </script>
</homo-content>
