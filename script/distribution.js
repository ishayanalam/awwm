<script>
        const distributeModal = document.getElementById("distributeModal");
        const reportModal = document.getElementById("reportModal");

        const distributeBtn = document.getElementById("distributeBtn");
        const reportBtn = document.getElementById("reportBtn");
        const manageBtn = document.getElementById("manageBtn");

        // popup close(lab)
        const closeBtns = document.getElementsByClassName("close");

        // distribute e click krle popup window open(lab)
        distributeBtn.onclick = function () {
          distributeModal.style.display = "block";
        };

        // view e click krle popup window open(lab)
        reportBtn.onclick = function () {
          reportModal.style.display = "block";
        };

        // manage e click krle area page e jai(lab)
        manageBtn.onclick = function () {
          window.location.href = "areas.html";
        };

        for (let i = 0; i < closeBtns.length; i++) {
          closeBtns[i].onclick = function () {
            distributeModal.style.display = "none";
            reportModal.style.display = "none";
          };
        }

        window.onclick = function (event) {
          if (event.target == distributeModal) {
            distributeModal.style.display = "none";
          }
          if (event.target == reportModal) {
            reportModal.style.display = "none";
          }
        };
        // submission form handle kora(lab)
        document.getElementById("distributeForm").onsubmit = function (e) {
          e.preventDefault();
          // value pass krsi(lab)
          const area = document.getElementById("areaSelect").value;
          const amount = document.getElementById("waterAmount").value;
          const date = document.getElementById("distributionDate").value;

          alert(
            `Water distribution scheduled for ${area}:\nAmount: ${amount} Liters\nDate: ${date}`
          );
          // popup close(lab)
          distributeModal.style.display = "none";
          this.reset();
        };
      </script>