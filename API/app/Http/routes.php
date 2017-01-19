<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

$api = app('Dingo\Api\Routing\Router');

Route::get('/', function () {
    return view('welcome');
});

$api->version('v1', function($api){

    $api->get('date/{date}/temps', 'App\Http\Controllers\HomeController@getTemps');

    $api->get('date/temps/all', 'App\Http\Controllers\HomeController@getTempsAll');

    $api->get('date/temps/now/{rasp_mac}', 'App\Http\Controllers\HomeController@getTempsNow');

    $api->get('date/regs/all', 'App\Http\Controllers\HomeController@getRegAll');

    $api->get('date/temps/{rasp_mac}', 'App\Http\Controllers\HomeController@getTempMac');

    $api->get('date/{date}/temps/{rasp_mac}', 'App\Http\Controllers\HomeController@TempCompare');

    $api->get('date/regs/{mac_adres}', 'App\Http\Controllers\HomeController@getRegMac');

    $api->get('register/mac/{mac_rasp}/ip/{ip_rasp}', 'App\Http\Controllers\HomeController@registerRasp');

    $api->get('temp/{temp_value}/air/{air}/device/{device_adres}/location/{rasp_mac}/ip_adres/{local_ip}/temp_buiten/{temp_buiten}/air_buiten/{air_buiten}', 'App\Http\Controllers\HomeController@setTempsNew');

    $api->get('register_user/{device_mac}/{rasp_mac}/location/{location}', 'App\Http\Controllers\HomeController@registerUser');

    $api->get('check/registerUser/{mac_adres}', 'App\Http\Controllers\HomeController@checkMacDevice');

    $api->get('last7days/{rasp_mac}', 'App\Http\Controllers\HomeController@avg_date');

    $api->get('system/{device_mac}/collectData','App\Http\Controllers\HomeController@systemData');
});

Route::get('/home', 'HomeController@index');
