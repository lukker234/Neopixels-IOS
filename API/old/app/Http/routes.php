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

//Route::get('/', function () {
//    return view('welcome');
//});
//
//Route::get('/hans', function () {
//    return("Hans");
//});

$api = app('Dingo\Api\Routing\Router');

Route::get('/', function () {
    return view('welcome');
});

$api->version('v1', function($api){
    $api->get('hello', 'App\Http\Controllers\HomeController@index');

    $api->get('user/{user_id}/roles/{role_name}', 'App\Http\Controllers\HomeController@attachUserRole');

    $api->get('user/{user_id}/roles', 'App\Http\Controllers\HomeController@getUserRole');

    $api->post('role/permission/add', 'App\Http\Controllers\HomeController@attachPermission');

    $api->get('temp/{temp}/humid/{humid}/add', 'App\Http\Controllers\HomeController@addRow');

    $api->get('role/{user_name}/permissions', 'App\Http\Controllers\HomeController@getPermissions');

    $api->get('date/{date}/temps', 'App\Http\Controllers\HomeController@getTemps');

    $api->get('date/temps', 'App\Http\Controllers\HomeController@getTempsAll');

    $api->get('date/temps/{rasp_mac}', 'App\Http\Controllers\HomeController@getTempsMac');

    $api->get('check/register/{mac_adres}', 'App\Http\Controllers\HomeController@checkMacRasp');

    $api->get('register/mac/{mac_rasp}/ip/{ip_rasp}', 'App\Http\Controllers\HomeController@registerRasp');

    $api->get('register/showAll', 'App\Http\Controllers\HomeController@showRegistered');

    $api->get('temp/{temp_value}/air/{air}/device/{device_adres}/location/{rasp_mac}/ip_adres/{local_ip}', 'App\Http\Controllers\HomeController@setTempsNew');
});