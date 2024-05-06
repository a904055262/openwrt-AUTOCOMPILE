'use strict';
'require baseclass';
'require fs';
'require rpc';

var callLuciVersion = rpc.declare({
	object: 'luci',
	method: 'getVersion'
});

var callSystemBoard = rpc.declare({
	object: 'system',
	method: 'board'
});

var callSystemInfo = rpc.declare({
	object: 'system',
	method: 'info'
});

var callCPUUsage = rpc.declare({
	object: 'luci',
	method: 'getCPUUsage'
});

var callTempInfo = rpc.declare({
	object: 'luci',
	method: 'getTempInfo'
});

var callFanSpeed = rpc.declare({
	object: 'luci',
	method: 'getFanSpeed'
});

var callCpuFreq = rpc.declare({
	object: 'luci',
	method: 'getCpuFreq'
});

var callOnlineUsers = rpc.declare({
	object: 'luci',
	method: 'getOnlineUsers'
});

var callCPUBench = rpc.declare({
	object: 'luci',
	method: 'getCPUBench'
});

return baseclass.extend({
	title: _('System'),

	load: function() {
		return Promise.all([
			L.resolveDefault(callSystemBoard(), {}),
			L.resolveDefault(callSystemInfo(), {}),
			L.resolveDefault(callLuciVersion(), { revision: _('unknown version'), branch: 'LuCI' }),
			L.resolveDefault(callCPUUsage(), {}),
			L.resolveDefault(callTempInfo(), {}),
			L.resolveDefault(callCpuFreq(), {}),
			L.resolveDefault(callOnlineUsers(), {}),
			L.resolveDefault(callCPUBench(), {}),
			L.resolveDefault(callFanSpeed(), {}),
		]);
	},

	render: function(data) {
		var boardinfo   = data[0],
		    systeminfo  = data[1],
		    luciversion = data[2],
			cpuusage    = data[3],
			tempinfo    = data[4],
			cpufreq     = data[5],
			onlineusers = data[6],
			cpubench    = data[7],
			fanspeed    = data[8];

		luciversion = luciversion.branch + ' ' + luciversion.revision;

		var datestr = null;

		if (systeminfo.localtime) {
			var date = new Date(systeminfo.localtime * 1000);

			datestr = '%04d-%02d-%02d %02d:%02d:%02d'.format(
				date.getUTCFullYear(),
				date.getUTCMonth() + 1,
				date.getUTCDate(),
				date.getUTCHours(),
				date.getUTCMinutes(),
				date.getUTCSeconds()
			);
		}

		var fields = [
			_('Hostname'),         boardinfo.hostname,
			_('Model'),            boardinfo.model + cpubench.cpubench,
			_('Architecture'),     boardinfo.system,
			_('Target Platform'),  (L.isObject(boardinfo.release) ? boardinfo.release.target : ''),
			_('Firmware Version'), (L.isObject(boardinfo.release) ? boardinfo.release.description + ' / ' : '') + (luciversion || ''),
			_('Kernel Version'),   boardinfo.kernel,
			_('Local Time'),       datestr,
			_('Uptime'),           (systeminfo.uptime ? '%t'.format(systeminfo.uptime) : null) + ' | 在线设备: ' + onlineusers.onlineusers,
			_('Load Average'),     Array.isArray(systeminfo.load) ? '%.2f, %.2f, %.2f'.format(
				systeminfo.load[0] / 65535.0,
				systeminfo.load[1] / 65535.0,
				systeminfo.load[2] / 65535.0
			) : null,
			_('CPU'),    cpuusage.cpuusage + 
				( ! /^$|^error$/i.test(tempinfo.tempinfo) ?  ( ' | 温度: ' + tempinfo.tempinfo ) : '' ) + 
				( ! /^$|^error$/i.test(fanspeed.fanspeed) ?  ( ' | 风扇: ' + fanspeed.fanspeed ) : '' ) + 
				' | 频率: ' + cpufreq.cpufreq,

		];

		var table = E('table', { 'class': 'table' });

		for (var i = 0; i < fields.length; i += 2) {
			table.appendChild(E('tr', { 'class': 'tr' }, [
				E('td', { 'class': 'td left', 'width': '33%' }, [ fields[i] ]),
				E('td', { 'class': 'td left' }, [ (fields[i + 1] != null) ? fields[i + 1] : '?' ])
			]));
		}

		return table;
	}
});
