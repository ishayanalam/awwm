<script>
       function openPopup(popupId) {
         document.getElementById(popupId).style.display = 'flex';
       }
 
       function closePopup(popupId) {
         document.getElementById(popupId).style.display = 'none';
       }
 
       window.onclick = function(event) {
         if (event.target.className === 'popup') {
           event.target.style.display = 'none';
         }
       }
     </script>