/* Synthetic flat-cash-flow scenario. All amounts stay in the current page. */
(function () {
  'use strict';
  var form = document.getElementById('runway-form');
  if (!form) return;
  var inputs = ['opening-cash', 'cash-in', 'cash-out'].map(function (id) { return document.getElementById(id); });
  var result = document.getElementById('runway-result');
  var table = document.getElementById('cash-projection');
  var download = document.getElementById('download-scenario');
  var money = new Intl.NumberFormat('en', { style: 'currency', currency: 'TRY', maximumFractionDigits: 2 });
  var state;
  function update() {
    var valid = inputs.every(function (input) { return input.value.trim() !== '' && input.validity.valid && Number.isFinite(Number(input.value)); });
    download.disabled = !valid;
    table.hidden = !valid;
    if (!valid) {
      state = null;
      result.textContent = 'Enter a valid non-negative amount in every field (maximum TRY 1 trillion, at most two decimal places).';
      return;
    }
    var cash = Number(inputs[0].value), inflow = Number(inputs[1].value), outflow = Number(inputs[2].value);
    // Calculate in cents to avoid binary rounding changing the zero-burn case.
    var burn = (Math.round(outflow * 100) - Math.round(inflow * 100)) / 100;
    var runway = burn > 0 ? cash / burn : null;
    state = { cash: cash, inflow: inflow, outflow: outflow, burn: burn, runway: runway };
    if (burn > 0) result.textContent = 'Monthly net burn: ' + money.format(burn) + '. Runway: ' + runway.toLocaleString('en', { maximumFractionDigits: 2 }) + ' months' + (cash === 0 ? ' (no opening cash).' : '.');
    else if (burn === 0) result.textContent = 'Break-even: monthly net burn is zero. Cash does not deplete under these flat monthly flows.';
    else result.textContent = 'Monthly surplus: ' + money.format(-burn) + '. Runway is not limited by operating burn in this model.';
    var tbody = table.querySelector('tbody');
    tbody.replaceChildren();
    [0, 3, 6, 12].forEach(function (month) {
      var row = document.createElement('tr');
      var label = document.createElement('th');
      label.scope = 'row'; label.textContent = String(month);
      var value = document.createElement('td');
      value.className = 'number'; value.textContent = money.format(cash - burn * month);
      row.append(label, value); tbody.appendChild(row);
    });
  }
  form.addEventListener('input', update);
  form.addEventListener('submit', function (event) { event.preventDefault(); update(); });
  form.addEventListener('reset', function () { setTimeout(update, 0); });
  download.addEventListener('click', function () {
    if (!state) return;
    var lines = ['Month,Projected cash (TRY),Starting cash (TRY),Monthly inflows (TRY),Monthly outflows (TRY),Net burn (TRY),Runway (months)'];
    for (var month = 0; month <= 12; month++) lines.push([month, (state.cash - state.burn * month).toFixed(2), state.cash, state.inflow, state.outflow, state.burn, state.runway === null ? 'Not limited by operating burn' : state.runway].join(','));
    var url = URL.createObjectURL(new Blob([lines.join('\r\n') + '\r\n'], { type: 'text/csv;charset=utf-8' }));
    var link = document.createElement('a');
    link.href = url; link.download = 'synthetic-runway-scenario.csv'; link.click();
    setTimeout(function () { URL.revokeObjectURL(url); }, 1000);
  });
  form.hidden = false;
  update();
}());
